# 🔍 Checklist de Debug - Erro 502 Bad Gateway

Use este checklist quando encontrar erro 502 novamente.

---

## ⚡ Verificações Rápidas (Execute em ordem)

### 1️⃣ Verificar Status dos Containers
```bash
docker compose ps
```
**Esperado:** Todos os containers em estado `Up`  
**Se falhar:** Um container está parado. Execute `docker compose up -d`

---

### 2️⃣ Verificar Logs da Aplicação
```bash
docker compose logs app --tail=100
```

**Procure por:**
- ✅ `NOTICE: ready to handle connections` → OK
- ❌ `npm ERR! Missing script: "build"` → Problema no `package.json`
- ❌ `ERROR in` → Erro de build (Vite/assets)

---

### 3️⃣ Verificar Logs do Nginx
```bash
docker compose logs nginx --tail=50 | grep -i error
```

**Procure por:**
- ✅ Sem erros → OK
- ❌ `connect() failed` → Container PHP-FPM não está respondendo
- ❌ `upstream` → Problema de conexão com app

---

### 4️⃣ Validar `package.json`
```bash
# Listar scripts disponíveis
docker compose exec app npm run

# Deve mostrar:
# build
#   vite build
# dev
#   vite
# preview
#   vite preview
```

**Se falhar:** `package.json` está corrupto. Restaure do backup:
```bash
cat package-lock.json.backup | head -20  # Ver estrutura do antigo
# Se necessário, recriar conforme TROUBLESHOOTING.md
```

---

### 5️⃣ Verificar Arquivo Entrypoint
```bash
# Ver últimas 10 linhas do entrypoint.sh
tail -10 docker/entrypoint.sh

# Deve terminar com:
# exec php-fpm -F
```

**Se houver código após `exec php-fpm -F`:** Há duplicação. Remova.

---

## 🔧 Soluções Rápidas

### Solução 1: Reconstruir Containers
```bash
docker compose down
docker compose up -d --build

# Aguarde 30 segundos e verifique
sleep 30
docker compose logs app | tail -20
```

### Solução 2: Limpar Cache e Reconstruir
```bash
docker compose down -v  # Remove volumes
docker compose up -d --build

# Aguarde
sleep 30
docker compose logs app | tail -20
```

### Solução 3: Verificar espaço em disco
```bash
# Se estiver sem espaço, Docker não consegue criar volumes/containers
df -h

# Se necessário, limpar imagens não usadas
docker image prune -a
```

---

## 🚨 Sinais de Alerta

| Sinal | Causa Provável | Solução |
|-------|----------------|---------|
| `npm ERR! Missing script` | `package.json` inválido | Recriar arquivo com scripts |
| `connect() failed` | PHP-FPM não está rodando | Verificar logs do container `app` |
| `vite build error` | Erro de assets/CSS/JS | Verificar arquivos em `resources/` |
| `502 Bad Gateway` | Nginx não consegue conectar ao app | Verificar conexão entre containers |
| `Connection refused` | Porto 9000 não está escutando | Verificar inicialização do PHP-FPM |

---

## 📊 Diagnóstico Completo (Execute uma vez)

Se as verificações rápidas não funcionarem, execute isto:

```bash
#!/bin/bash

echo "=== DIAGNÓSTICO COMPLETO ==="
echo ""

echo "1. Status dos containers:"
docker compose ps
echo ""

echo "2. Últimos 30 logs da app:"
docker compose logs app --tail=30
echo ""

echo "3. Últimos 30 logs do nginx:"
docker compose logs nginx --tail=30
echo ""

echo "4. Scripts disponíveis no npm:"
docker compose exec app npm run 2>/dev/null || echo "❌ Não conseguiu conectar"
echo ""

echo "5. Verificar conectividade app→nginx:"
docker compose exec nginx wget -q -O- http://app:9000/ 2>&1 | head -5 || echo "❌ Sem conexão"
echo ""

echo "=== FIM DO DIAGNÓSTICO ==="
```

Salve este script como `diagnose.sh` e execute:
```bash
chmod +x diagnose.sh
./diagnose.sh
```

---

## 📞 Quando Procurar Ajuda

Se após seguir este checklist o problema persistir:

1. Anexar saída completa de:
   ```bash
   docker compose logs app
   docker compose logs nginx
   docker compose ps
   ```

2. Descrever:
   - Quando começou o erro (depois de qual ação?)
   - Se `package.json` foi modificado
   - Se `docker/entrypoint.sh` foi editado

3. Verificar:
   - Espaço em disco (`df -h`)
   - Memória disponível (`free -h`)
   - Se há containers antigos conflitando (`docker ps -a`)

---

**Última atualização:** 04/02/2026
