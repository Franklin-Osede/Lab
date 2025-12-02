# Franklin's Lab

Enterprise-grade experimentation and learning repository featuring advanced debugging techniques, Web3 development, DevOps automation, and full-stack applications.

**This repository is a Work in Progress (WIP)** - Continuously evolving with new projects, experiments, and technical demonstrations.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Technologies & Areas of Focus](#technologies--areas-of-focus)
- [Getting Started](#getting-started)
- [Development](#development)
- [Testing](#testing)
- [Documentation](#documentation)
- [License](#license)

## Overview

Franklin's Lab is a comprehensive experimentation space designed to explore and demonstrate cutting-edge technologies across multiple domains. The repository serves as a playground for prototyping, refining, and pushing the boundaries of software development, cloud infrastructure, and blockchain solutions.

### Key Features

- **Advanced Debugging Projects**: Spring Boot applications with intentional bugs demonstrating N+1 problems, validation issues, performance bottlenecks, resilience patterns, and concurrency challenges
- **Web3 Development**: DeFi liquidity pools, smart contracts, and blockchain security demonstrations
- **DevOps Automation**: GitHub Actions workflows, infrastructure as code, and CI/CD pipelines
- **Full-Stack Applications**: Book social network with Spring Boot backend and event-driven architecture
- **Testing Frameworks**: Playwright E2E tests, Cucumber BDD, and comprehensive test coverage
- **Educational Resources**: Git tutorials, markdown guides, and SSH key management

## Architecture

### High-Level Structure

```
Lab/
├── debugging-projects/          # Spring Boot debugging demonstrations
│   └── spring-boot-bugs/        # 5 intentional bug scenarios
├── web3-mini-projects/          # Blockchain and DeFi projects
│   └── 01-defi-liquidity-pool/ # Advanced DeFi AMM implementation
├── apps/                        # Full-stack applications
│   └── book-social-network/     # Social network for book lovers
├── github-actions/              # CI/CD workflow templates
├── github-sdks/                 # GitHub API SDKs (JS, Ruby, Terraform)
├── demos-playwright/            # E2E testing demonstrations
└── [educational-resources]/     # Git, markdown, SSH tutorials
```

### Technology Stack

**Backend Development:**
- Spring Boot 3.x with Java 17+
- Spring Data JPA with H2/PostgreSQL
- Spring WebFlux for reactive programming
- Spring Security for authentication
- Kafka for event-driven architecture
- NestJS with TypeScript (for microservices)

**Web3 & Blockchain:**
- Solidity 0.8.24+
- Hardhat 2.19.0
- Foundry 1.2.3
- OpenZeppelin contracts
- DeFi protocols and AMM implementations

**Testing & Quality:**
- JUnit 5 with Mockito
- Cucumber for BDD
- Playwright for E2E testing
- Vitest for frontend testing
- Gas optimization and coverage analysis

**DevOps & Infrastructure:**
- GitHub Actions for CI/CD
- Terraform for infrastructure as code
- Docker for containerization
- AWS SDK integrations

## Project Structure

### debugging-projects/

Advanced debugging demonstrations with Spring Boot applications featuring intentional bugs and their solutions.

```
debugging-projects/
├── spring-boot-bugs/
│   ├── 01-catalog-n1-problem/      # N+1 query problem demonstration
│   ├── 02-booking-validation/      # Date validation and error handling
│   ├── 03-login-performance/       # Latency and caching issues
│   ├── 04-payment-resilience/       # Timeouts and retry patterns
│   └── 05-inventory-concurrency/    # Concurrency and optimistic locking
└── README.md                        # Debugging projects documentation
```

**Key Features:**
- Domain-Driven Design (DDD) architecture
- TDD/BDD with Cucumber
- Advanced debugging techniques (breakpoints, logpoints, metrics)
- Observability with Spring Boot Actuator and Micrometer
- Resilience patterns (circuit breaker, retry)

### web3-mini-projects/

Blockchain and DeFi development projects with comprehensive testing and security demonstrations.

```
web3-mini-projects/
└── 01-defi-liquidity-pool/
    ├── contracts/                   # Solidity smart contracts
    │   ├── DeFiLiquidityPool.sol   # Main AMM contract
    │   ├── interfaces/              # Contract interfaces
    │   ├── libraries/               # Math and utility libraries
    │   └── mocks/                   # Test contracts
    ├── test/                        # Comprehensive test suites
    │   ├── DeFiLiquidityPool.basic.test.js  # Hardhat tests
    │   └── DeFiLiquidityPool.t.sol          # Foundry tests
    └── scripts/                     # Deployment and demo scripts
```

**Key Features:**
- AMM (Automated Market Maker) with x * y = k formula
- Dynamic fees (0.1% - 1%) based on volatility
- MEV protections
- Flash loans (educational vulnerabilities)
- Exhaustive testing (19 tests: Hardhat + Foundry)
- Fuzzing and invariant testing

### apps/

Full-stack applications demonstrating real-world use cases.

```
apps/
└── book-social-network/
    └── backend/                    # Spring Boot backend
        ├── src/
        │   ├── main/               # Application code
        │   └── test/               # Test suites
        └── pom.xml                 # Maven dependencies
```

**Key Features:**
- Spring Boot 2.7.12 with Java 17
- Spring Data JPA with H2 database
- Kafka integration for event-driven architecture
- RESTful API design
- TDD approach with comprehensive test coverage

### github-actions/

Reusable GitHub Actions workflow templates and examples.

```
github-actions/
├── templates/                      # Workflow templates
│   ├── azure-static-web-apps.yml
│   ├── docker-hub.yml
│   ├── postgres-container.yml
│   ├── schedule.yml
│   └── [20+ more templates]
└── pg/                            # PostgreSQL client examples
```

**Key Features:**
- CI/CD pipeline templates
- Multi-platform support (Linux, macOS, Windows)
- Container orchestration
- Database integration examples
- Release automation

### github-sdks/

GitHub API SDK implementations in multiple languages.

```
github-sdks/
├── js/                            # JavaScript/Node.js SDK
├── ruby/                          # Ruby SDK
└── terraform/                     # Terraform provider examples
```

### demos-playwright/

End-to-end testing demonstrations with Playwright and Cucumber.

```
demos-playwright/
├── src/
│   ├── features/                  # Gherkin feature files
│   └── step-definitions/          # Step implementation
└── playwright.config.ts           # Playwright configuration
```

## Technologies & Areas of Focus

### Web3 & Blockchain

- **Ethereum & Smart Contracts**: Solidity, Hardhat, Foundry, Brownie
- **DeFi Strategies**: AMM implementations, liquidity pools, flash loans
- **Security**: Reentrancy protection, MEV mitigation, audit practices
- **Testing**: Fuzzing, invariant testing, gas optimization

### Backend Development

- **Languages**: Java, TypeScript, Python, Go, Rust
- **Frameworks**: Spring Boot, NestJS, Express.js, Django, FastAPI
- **Databases**: PostgreSQL, MySQL, MongoDB, H2, Redis
- **API Development**: REST, GraphQL, gRPC, OpenAPI
- **Event-Driven**: Kafka, RabbitMQ, Google Pub/Sub
- **Architecture**: Domain-Driven Design, Clean Architecture, Microservices

### DevOps & Cloud Infrastructure

- **Infrastructure as Code**: Terraform, Pulumi, AWS CDK
- **Containerization**: Docker, Kubernetes, Helm
- **CI/CD**: GitHub Actions, GitLab CI, Jenkins
- **Cloud Providers**: AWS, Google Cloud, Azure
- **Monitoring**: Grafana, Prometheus, CloudWatch, ELK Stack

### Testing & Quality Assurance

- **Unit Testing**: JUnit, Jest, Vitest, pytest
- **Integration Testing**: Spring Boot Test, Testcontainers
- **E2E Testing**: Playwright, Cypress, Selenium
- **BDD**: Cucumber, Gherkin
- **Code Quality**: SonarQube, ESLint, Checkstyle

## Getting Started

### Prerequisites

- **Java**: JDK 17+ (for Spring Boot projects)
- **Node.js**: v18+ and npm (for Web3 and frontend projects)
- **Docker**: For containerized applications
- **Git**: For version control
- **Terraform**: v1.5+ (for infrastructure projects)
- **Foundry**: For Solidity development (optional)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd Lab

# Install dependencies for specific projects
cd web3-mini-projects/01-defi-liquidity-pool
npm install

# Or for Spring Boot projects
cd debugging-projects/spring-boot-bugs/01-catalog-n1-problem
./mvnw spring-boot:run
```

### Environment Setup

**Spring Boot Projects:**
```bash
cd debugging-projects/spring-boot-bugs/01-catalog-n1-problem
./mvnw spring-boot:run
# Application available at http://localhost:8080
```

**Web3 Projects:**
```bash
cd web3-mini-projects/01-defi-liquidity-pool
npm install
npm run compile
npm run test
```

**Playwright Tests:**
```bash
cd demos-playwright
npm install
npx playwright test
```

## Development

### Debugging Projects

Each debugging project follows a structured approach:

1. **Problem Presentation**: Context and business scenario
2. **Test-Driven Development**: BDD tests in Gherkin
3. **Live Debugging**: Breakpoints, logpoints, metrics analysis
4. **DDD Solution**: Refactoring following Domain-Driven Design principles
5. **Validation**: Tests passing, improved metrics, final demonstration

**Example - N+1 Problem:**
```bash
cd debugging-projects/spring-boot-bugs/01-catalog-n1-problem
./mvnw spring-boot:run

# Test buggy endpoint
curl http://localhost:8080/api/v1/products/with-n1-bug

# Test optimized endpoint
curl http://localhost:8080/api/v1/products/optimized
```

### Web3 Development

**DeFi Liquidity Pool:**
```bash
cd web3-mini-projects/01-defi-liquidity-pool

# Run Hardhat tests
npm run test

# Run Foundry tests
forge test

# Run fuzzing tests
npm run test:fuzz

# Generate coverage report
npm run test:coverage
```

### Full-Stack Applications

**Book Social Network:**
```bash
cd apps/book-social-network/backend
./mvnw spring-boot:run

# Run tests
./mvnw test
```

## Testing

### Test Strategy

**Unit Tests:**
- Domain entities and business logic
- Shared utilities
- Component-level testing

**Integration Tests:**
- Spring Boot controllers
- Database repositories
- External service adapters

**E2E Tests:**
- Complete user workflows
- Playwright browser automation
- Cucumber BDD scenarios

### Running Tests

**Spring Boot Projects:**
```bash
cd debugging-projects/spring-boot-bugs/01-catalog-n1-problem
./mvnw test                    # All tests
./mvnw test -Dtest=CucumberTest  # BDD tests only
```

**Web3 Projects:**
```bash
cd web3-mini-projects/01-defi-liquidity-pool
npm run test              # Hardhat tests
forge test                # Foundry tests
npm run test:fuzz         # Fuzzing (10,000 runs)
npm run test:coverage     # Coverage report
```

**Playwright Tests:**
```bash
cd demos-playwright
npx playwright test
npx playwright test --ui  # UI mode
```

## Documentation

### Project-Specific Documentation

- **Debugging Projects**: `/debugging-projects/README.md`
- **DeFi Liquidity Pool**: `/web3-mini-projects/01-defi-liquidity-pool/README.md`
- **Catalog N+1 Problem**: `/debugging-projects/spring-boot-bugs/01-catalog-n1-problem/README.md`
- **Architecture**: `/debugging-projects/spring-boot-bugs/01-catalog-n1-problem/ARCHITECTURE.md`

### Educational Resources

- **Git Tutorial**: `/git-crash-course/Readme.md`
- **Markdown Guide**: `/markdown/Readme.md`
- **SSH Keys**: `/ssh-keys/Readme.md`
- **GitHub Actions**: `/github-actions/Readme.me`

## Roadmap

### Completed

- Spring Boot debugging projects with DDD architecture
- DeFi liquidity pool with comprehensive testing
- GitHub Actions workflow templates
- Playwright E2E testing setup
- Book social network backend foundation

### In Progress

- Additional Spring Boot bug scenarios
- Enhanced Web3 security demonstrations
- CI/CD pipeline automation
- Infrastructure as code modules

### Planned

- Angular frontend for debugging projects
- Additional DeFi protocols
- Kubernetes deployment configurations
- Advanced monitoring and observability
- Multi-language SDK implementations

## Contributing

This is a private repository. For contributions, please contact the project maintainers.

## License

Private - Franklin's Lab

All rights reserved. This software is proprietary and confidential.

## Support

For technical support or questions:

- **Documentation**: See project-specific README files
- **Issues**: Review project documentation and code comments
- **Debugging**: Check Spring Boot Actuator endpoints and CloudWatch logs

---

**Built for continuous learning and experimentation in modern software engineering**
