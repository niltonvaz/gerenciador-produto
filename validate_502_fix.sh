#!/bin/bash

# Script de Validação - Erro 502 Bad Gateway
# Verifica se a solução foi aplicada corretamente
# Uso: ./validate_502_fix.sh

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   VALIDAÇÃO DE SOLUÇÃO - ERRO 502 BAD GATEWAY                  ║"
echo "║   Data: $(date +%d/%m/%Y' às '%H:%M:%S)                                   ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Função para imprimir resultado
print_result() {
    local test_name=$1
    local result=$2
    local details=$3
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC} - $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    elif [ "$result" = "FAIL" ]; then
        echo -e "${RED}❌ FAIL${NC} - $test_name"
        if [ -n "$details" ]; then
            echo -e "   ${RED}Detalhes: $details${NC}"
        fi
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo -e "${YELLOW}⚠️  WARN${NC} - $test_name"
        if [ -n "$details" ]; then
            echo -e "   ${YELLOW}Detalhes: $details${NC}"
        fi
    fi
    echo ""
}

# ============================================================================
# TESTE 1: Verificar se package.json existe e é válido
# ============================================================================
echo -e "${BLUE}[TESTE 1/8]${NC} Validando package.json..."

if [ ! -f "package.json" ]; then
    print_result "Arquivo package.json existe" "FAIL" "Arquivo não encontrado"
else
    # Verificar se é JSON válido
    if jq empty < package.json 2>/dev/null; then
        print_result "Arquivo package.json é JSON válido" "PASS"
    else
        print_result "Arquivo package.json é JSON válido" "FAIL" "JSON inválido"
    fi
fi

# ============================================================================
# TESTE 2: Verificar se package.json tem section scripts
# ============================================================================
echo -e "${BLUE}[TESTE 2/8]${NC} Validando seção de scripts..."

if jq '.scripts' package.json > /dev/null 2>&1; then
    SCRIPTS=$(jq '.scripts | keys[]' package.json 2>/dev/null | tr '\n' ',' | sed 's/,$//')
    print_result "Section 'scripts' existe em package.json" "PASS"
    echo "   Scripts encontrados: $SCRIPTS"
    echo ""
else
    print_result "Section 'scripts' existe em package.json" "FAIL" "Scripts não encontrados"
fi

# ============================================================================
# TESTE 3: Verificar se script 'build' existe
# ============================================================================
echo -e "${BLUE}[TESTE 3/8]${NC} Validando script 'build'..."

if jq '.scripts.build' package.json > /dev/null 2>&1; then
    BUILD_CMD=$(jq -r '.scripts.build' package.json)
    print_result "Script 'build' definido" "PASS"
    echo "   Comando: $BUILD_CMD"
    echo ""
else
    print_result "Script 'build' definido" "FAIL" "Script build não encontrado"
fi

# ============================================================================
# TESTE 4: Verificar se script 'dev' existe
# ============================================================================
echo -e "${BLUE}[TESTE 4/8]${NC} Validando script 'dev'..."

if jq '.scripts.dev' package.json > /dev/null 2>&1; then
    DEV_CMD=$(jq -r '.scripts.dev' package.json)
    print_result "Script 'dev' definido" "PASS"
    echo "   Comando: $DEV_CMD"
    echo ""
else
    print_result "Script 'dev' definido" "FAIL" "Script dev não encontrado"
fi

# ============================================================================
# TESTE 5: Verificar integridade do entrypoint.sh
# ============================================================================
echo -e "${BLUE}[TESTE 5/8]${NC} Validando docker/entrypoint.sh..."

if [ ! -f "docker/entrypoint.sh" ]; then
    print_result "Arquivo docker/entrypoint.sh existe" "FAIL" "Arquivo não encontrado"
else
    print_result "Arquivo docker/entrypoint.sh existe" "PASS"
    
    # Verificar se termina com exec php-fpm
    if tail -3 docker/entrypoint.sh | grep -q "exec php-fpm -F"; then
        print_result "entrypoint.sh termina com 'exec php-fpm -F'" "PASS"
    else
        print_result "entrypoint.sh termina com 'exec php-fpm -F'" "FAIL" "Última linha não é exec php-fpm"
    fi
    
    # Verificar se há código depois do exec
    LINES_AFTER_EXEC=$(tail -1 docker/entrypoint.sh | grep -c "exec php-fpm" || true)
    if [ "$LINES_AFTER_EXEC" -eq 1 ]; then
        print_result "Nenhum código após 'exec php-fpm -F'" "PASS"
    else
        print_result "Nenhum código após 'exec php-fpm -F'" "WARN" "Possível código duplicado"
    fi
fi

# ============================================================================
# TESTE 6: Verificar Docker containers
# ============================================================================
echo -e "${BLUE}[TESTE 6/8]${NC} Validando containers Docker..."

if ! command -v docker &> /dev/null; then
    print_result "Docker instalado" "FAIL" "Docker não encontrado no PATH"
else
    print_result "Docker instalado" "PASS"
    
    # Verificar se containers existem
    if docker ps --format '{{.Names}}' | grep -q "laravel_app"; then
        STATUS=$(docker ps --filter name=laravel_app --format '{{.State}}')
        if [ "$STATUS" = "running" ]; then
            print_result "Container laravel_app está rodando" "PASS"
        else
            print_result "Container laravel_app está rodando" "FAIL" "Status: $STATUS"
        fi
    else
        print_result "Container laravel_app existe" "FAIL" "Container não encontrado"
    fi
    
    if docker ps --format '{{.Names}}' | grep -q "laravel_nginx"; then
        STATUS=$(docker ps --filter name=laravel_nginx --format '{{.State}}')
        if [ "$STATUS" = "running" ]; then
            print_result "Container laravel_nginx está rodando" "PASS"
        else
            print_result "Container laravel_nginx está rodando" "FAIL" "Status: $STATUS"
        fi
    else
        print_result "Container laravel_nginx existe" "FAIL" "Container não encontrado"
    fi
fi

# ============================================================================
# TESTE 7: Verificar logs da aplicação
# ============================================================================
echo -e "${BLUE}[TESTE 7/8]${NC} Validando logs da aplicação..."

if ! command -v docker &> /dev/null; then
    print_result "Verificar logs do container" "WARN" "Docker não disponível"
else
    if docker ps --format '{{.Names}}' | grep -q "laravel_app"; then
        # Procurar por erros de npm
        if docker compose logs app 2>/dev/null | grep -q "npm ERR! Missing script"; then
            print_result "Sem erro 'Missing script' nos logs" "FAIL" "Script build ainda falta"
        else
            print_result "Sem erro 'Missing script' nos logs" "PASS"
        fi
        
        # Procurar por sucesso do PHP-FPM
        if docker compose logs app 2>/dev/null | grep -q "ready to handle connections"; then
            print_result "PHP-FPM ready to handle connections" "PASS"
        else
            print_result "PHP-FPM ready to handle connections" "FAIL" "PHP-FPM não está respondendo"
        fi
        
        # Procurar por erros de conexão nginx
        if docker compose logs nginx 2>/dev/null | grep -q "connect() failed"; then
            print_result "Sem erro de conexão no nginx" "FAIL" "Nginx não consegue conectar ao app"
        else
            print_result "Sem erro de conexão no nginx" "PASS"
        fi
    fi
fi

# ============================================================================
# TESTE 8: Verificar acesso HTTP
# ============================================================================
echo -e "${BLUE}[TESTE 8/8]${NC} Validando acesso HTTP..."

if command -v curl &> /dev/null; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000 2>/dev/null || echo "000")
    
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ] || [ "$HTTP_CODE" = "301" ]; then
        print_result "Aplicação respondendo sem erro 502" "PASS"
        echo "   HTTP Status: $HTTP_CODE"
        echo ""
    elif [ "$HTTP_CODE" = "502" ]; then
        print_result "Aplicação respondendo sem erro 502" "FAIL" "HTTP Status: 502 Bad Gateway"
    else
        print_result "Aplicação respondendo sem erro 502" "WARN" "HTTP Status: $HTTP_CODE (possível aplicação offline)"
    fi
else
    print_result "curl disponível para teste HTTP" "WARN" "curl não encontrado, teste não realizado"
fi

# ============================================================================
# RESULTADO FINAL
# ============================================================================
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                         RESULTADO FINAL                        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PERCENTAGE=$((TESTS_PASSED * 100 / TESTS_TOTAL))

echo "Testes executados: $TESTS_TOTAL"
echo -e "Passou: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Falhou: ${RED}$TESTS_FAILED${NC}"
echo "Percentual: $PERCENTAGE%"
echo ""

if [ $TESTS_FAILED -eq 0 ] && [ $PERCENTAGE -ge 80 ]; then
    echo -e "${GREEN}✅ SOLUÇÃO VALIDADA COM SUCESSO!${NC}"
    echo ""
    echo "A solução para o erro 502 foi aplicada corretamente."
    echo "Todos os componentes estão funcionando como esperado."
    exit 0
elif [ $PERCENTAGE -ge 50 ]; then
    echo -e "${YELLOW}⚠️  SOLUÇÃO PARCIALMENTE VALIDADA${NC}"
    echo ""
    echo "Alguns testes falharam. Verifique os detalhes acima."
    exit 1
else
    echo -e "${RED}❌ SOLUÇÃO NÃO VALIDADA${NC}"
    echo ""
    echo "Vários testes falharam. Revise TROUBLESHOOTING.md"
    exit 1
fi
