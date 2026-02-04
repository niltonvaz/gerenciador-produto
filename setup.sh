#!/bin/bash

# Script de Setup Automático - Gerenciador de Produtos
# Executa todos os passos de setup do zero

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  🚀 SETUP AUTOMÁTICO - GERENCIADOR DE PRODUTOS                 ║"
echo "║  Este script vai configurar e iniciar a aplicação             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ============================================================================
# VERIFICAR PRÉ-REQUISITOS
# ============================================================================
echo -e "${BLUE}[1/4] Verificando pré-requisitos...${NC}"
echo ""

if ! command -v docker &> /dev/null; then
    echo "❌ Docker não está instalado"
    echo "   Instale em: https://docs.docker.com/get-docker/"
    exit 1
fi
echo "✅ Docker: $(docker --version)"

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose não está instalado"
    echo "   Instale em: https://docs.docker.com/compose/install/"
    exit 1
fi
echo "✅ Docker Compose: $(docker compose version | head -1)"

if ! command -v git &> /dev/null; then
    echo "❌ Git não está instalado"
    echo "   Instale em: https://git-scm.com/downloads"
    exit 1
fi
echo "✅ Git: $(git --version)"

echo ""

# ============================================================================
# CONSTRUIR E INICIAR CONTAINERS
# ============================================================================
echo -e "${BLUE}[2/4] Construindo e iniciando containers Docker...${NC}"
echo "(Isso pode levar alguns minutos na primeira vez)"
echo ""

docker compose down -v 2>/dev/null || true
docker compose up -d --build

echo ""
echo -e "${YELLOW}⏳ Aguardando aplicação inicializar (30 segundos)...${NC}"
sleep 30

echo ""

# ============================================================================
# VERIFICAR STATUS
# ============================================================================
echo -e "${BLUE}[3/4] Verificando status dos containers...${NC}"
echo ""

echo "Status dos containers:"
docker compose ps

echo ""

# Verificar se PHP-FPM está pronto
if docker compose logs app 2>/dev/null | grep -q "ready to handle connections"; then
    echo -e "${GREEN}✅ PHP-FPM está pronto${NC}"
else
    echo -e "${YELLOW}⚠️  PHP-FPM ainda inicializando...${NC}"
fi

# Verificar se Nginx está rodando
if docker compose ps | grep -q "laravel_nginx.*Up"; then
    echo -e "${GREEN}✅ Nginx está rodando${NC}"
else
    echo -e "❌ Nginx não está rodando"
    exit 1
fi

# Verificar se MySQL está rodando
if docker compose ps | grep -q "laravel_mysql.*Up"; then
    echo -e "${GREEN}✅ MySQL está rodando${NC}"
else
    echo -e "❌ MySQL não está rodando"
    exit 1
fi

echo ""

# ============================================================================
# TESTAR ACESSO
# ============================================================================
echo -e "${BLUE}[4/4] Testando acesso à aplicação...${NC}"
echo ""

sleep 5

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 2>/dev/null || echo "000")

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ] || [ "$HTTP_CODE" = "301" ]; then
    echo -e "${GREEN}✅ Aplicação respondendo com HTTP $HTTP_CODE${NC}"
elif [ "$HTTP_CODE" = "502" ]; then
    echo -e "❌ ERRO 502 - Bad Gateway"
    echo "   Execute: ./validate_502_fix.sh"
    echo "   ou consulte: TROUBLESHOOTING.md"
    exit 1
else
    echo -e "${YELLOW}⚠️  HTTP Status: $HTTP_CODE (possível timeout)${NC}"
fi

echo ""

# ============================================================================
# RESULTADO FINAL
# ============================================================================
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ SETUP CONCLUÍDO!                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}🎉 Sua aplicação está pronta!${NC}"
echo ""
echo "📱 Acesse no navegador:"
echo "   → http://localhost:8000"
echo ""
echo "📚 Documentação:"
echo "   → SETUP_GUIDE.md - Guia completo de setup"
echo "   → TROUBLESHOOTING.md - Se encontrar problemas"
echo "   → DEBUG_CHECKLIST.md - Diagnóstico rápido"
echo ""
echo "🛑 Para parar a aplicação:"
echo "   → docker compose down"
echo ""
echo "🔄 Para reiniciar:"
echo "   → docker compose up -d"
echo ""
