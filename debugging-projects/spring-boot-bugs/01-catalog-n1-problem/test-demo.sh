#!/bin/bash

# 🐛 Catalog N+1 Problem Demo Script
# This script demonstrates the N+1 problem and its solution

BASE_URL="http://localhost:8080/api/v1"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🐛 Catalog N+1 Problem Demo${NC}"
echo "=================================="
echo ""

# Function to measure response time
measure_response_time() {
    local url=$1
    local description=$2
    
    echo -e "${YELLOW}📊 Testing: $description${NC}"
    echo "URL: $url"
    
    # Measure response time
    start_time=$(date +%s%N)
    response=$(curl -s -w "\n%{http_code}" "$url")
    end_time=$(date +%s%N)
    
    # Extract status code and body
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)
    
    # Calculate time in milliseconds
    duration=$(( (end_time - start_time) / 1000000 ))
    
    echo -e "⏱️  Response time: ${duration}ms"
    echo -e "📡 Status Code: $http_code"
    
    if [ "$http_code" = "200" ]; then
        echo -e "${GREEN}✅ Success${NC}"
        echo -e "${CYAN}📄 Response (first 3 lines):${NC}"
        echo "$body" | head -n 3
    else
        echo -e "${RED}❌ Error${NC}"
        echo -e "${YELLOW}📄 Error response:${NC}"
        echo "$body" | head -n 5
        echo -e "${YELLOW}🔍 For more details, check the application logs${NC}"
    fi
    
    echo ""
}

# Function to show application information
show_app_info() {
    echo -e "${BLUE}🏥 Application Information${NC}"
    echo "================================"
    
    # Health check
    health_response=$(curl -s "$BASE_URL/products/health")
    echo "Status: $health_response"
    echo ""
}

# Function to compare performance
compare_performance() {
    echo -e "${BLUE}📈 Performance Comparison${NC}"
    echo "================================"
    
    performance_response=$(curl -s "$BASE_URL/products/performance-comparison")
    
    # Extract values using jq if available, otherwise use grep/sed
    if command -v jq &> /dev/null; then
        n1_time=$(echo "$performance_response" | jq -r '.n1ExecutionTime')
        optimized_time=$(echo "$performance_response" | jq -r '.optimizedExecutionTime')
        improvement=$(echo "$performance_response" | jq -r '.performanceImprovement')
    else
        # Fallback without jq
        n1_time=$(echo "$performance_response" | grep -o '"n1ExecutionTime":[0-9]*' | cut -d':' -f2)
        optimized_time=$(echo "$performance_response" | grep -o '"optimizedExecutionTime":[0-9]*' | cut -d':' -f2)
        improvement=$(echo "$performance_response" | grep -o '"performanceImprovement":"[^"]*"' | cut -d'"' -f4)
    fi
    
    echo -e "${RED}🐛 N+1 Implementation: ${n1_time}ms${NC}"
    echo -e "${GREEN}✅ Optimized Implementation: ${optimized_time}ms${NC}"
    echo -e "${BLUE}📊 Improvement: ${improvement}${NC}"
    echo ""
}

# Function to show Actuator metrics
show_actuator_metrics() {
    echo -e "${BLUE}📊 Actuator Metrics${NC}"
    echo "=========================="
    
    # General metrics
    metrics_response=$(curl -s "http://localhost:8080/api/v1/actuator/metrics")
    echo "Available metrics: $metrics_response"
    echo ""
    
    # Specific N+1 timer metric
    n1_metric=$(curl -s "http://localhost:8080/api/v1/actuator/metrics/catalog.list.products.with.n1.bug")
    echo "N+1 Timer: $n1_metric"
    echo ""
    
    # Specific optimized timer metric
    optimized_metric=$(curl -s "http://localhost:8080/api/v1/actuator/metrics/catalog.list.products.optimized")
    echo "Optimized Timer: $optimized_metric"
    echo ""
}

# Función para demostrar el problema N+1
demonstrate_n1_problem() {
    echo -e "${BLUE}🐛 Demostración del Problema N+1${NC}"
    echo "====================================="
    echo ""
    
    echo -e "${YELLOW}⚠️  ADVERTENCIA: Este endpoint será LENTO debido al problema N+1${NC}"
    echo "Con 30 productos, se ejecutarán 31 queries (1 + 30)"
    echo ""
    
    read -p "¿Continuar con la demostración? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        measure_response_time "$BASE_URL/products/with-n1-bug" "Endpoint N+1 (Lento)"
    else
        echo "Demostración cancelada"
    fi
}

# Función para demostrar la solución optimizada
demonstrate_optimized_solution() {
    echo -e "${BLUE}✅ Demostración de la Solución Optimizada${NC}"
    echo "============================================="
    echo ""
    
    echo -e "${GREEN}🚀 Este endpoint será RÁPIDO con 1 query optimizada${NC}"
    echo "Con 30 productos, se ejecutará 1 query con JOIN FETCH"
    echo ""
    
    measure_response_time "$BASE_URL/products/optimized" "Endpoint Optimizado (Rápido)"
}

# Función para ejecutar suite completa de pruebas
run_full_demo() {
    echo -e "${BLUE}🎬 Ejecutando Demo Completo${NC}"
    echo "==============================="
    echo ""
    
    # 1. Información de la aplicación
    show_app_info
    
    # 2. Demostrar problema N+1
    demonstrate_n1_problem
    
    # 3. Demostrar solución optimizada
    demonstrate_optimized_solution
    
    # 4. Comparar performance
    compare_performance
    
    # 5. Mostrar métricas
    show_actuator_metrics
    
    echo -e "${GREEN}🎉 Demo completado exitosamente!${NC}"
}

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}📖 Ayuda - Catalog N+1 Problem Demo${NC}"
    echo "=========================================="
    echo ""
    echo "Uso: $0 [OPCIÓN]"
    echo ""
    echo "Opciones:"
    echo "  info      - Mostrar información de la aplicación"
    echo "  n1        - Demostrar problema N+1 (lento)"
    echo "  optimized - Demostrar solución optimizada (rápido)"
    echo "  compare   - Comparar performance de ambas implementaciones"
    echo "  metrics   - Mostrar métricas de Actuator"
    echo "  demo      - Ejecutar demo completo"
    echo "  help      - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 demo      # Ejecutar demo completo"
    echo "  $0 n1        # Solo probar endpoint N+1"
    echo "  $0 compare   # Solo comparar performance"
    echo ""
}

# Verificar que la aplicación esté ejecutándose
check_app_running() {
    if ! curl -s "$BASE_URL/products/health" > /dev/null; then
        echo -e "${RED}❌ Error: La aplicación no está ejecutándose${NC}"
        echo "Por favor, ejecuta: ./mvnw spring-boot:run"
        echo ""
        exit 1
    fi
}

# Función principal
main() {
    # Verificar que la aplicación esté ejecutándose
    check_app_running
    
    case "${1:-demo}" in
        "info")
            show_app_info
            ;;
        "n1")
            demonstrate_n1_problem
            ;;
        "optimized")
            demonstrate_optimized_solution
            ;;
        "compare")
            compare_performance
            ;;
        "metrics")
            show_actuator_metrics
            ;;
        "demo")
            run_full_demo
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Opción desconocida: $1${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
