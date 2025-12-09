# Redfin Infrastructure

Redfin 프로젝트 전반 인프라 관리 및 배포 자동화를 담당하는 저장소입니다.

## 📋 개요

이 저장소는 Redfin 프로젝트의 핵심 인프라 서비스들을 Docker Compose로 관리합니다. API 게이트웨이, DNS 서버, 데이터베이스, 검색 엔진, CI/CD 등 개발 및 운영에 필요한 모든 인프라 컴포넌트를 포함합니다.

## 🏗️ 아키텍처

### 포함된 서비스

- **Nginx**: 리버스 프록시, API 게이트웨이, SSL/TLS 종료
- **CoreDNS**: 내부 DNS 서버 (`.redfin.dev` 도메인 관리)
- **MongoDB**: 문서 기반 데이터베이스
- **Mongo Express**: MongoDB 웹 관리 UI
- **Elasticsearch**: 검색 및 분석 엔진
- **Kibana**: Elasticsearch 시각화 및 대시보드
- **Jenkins**: CI/CD 파이프라인
- **Qdrant**: 벡터 데이터베이스 (RAG 시스템용)

## 🚀 빠른 시작

### 사전 요구사항

- Docker Engine 20.10+
- Docker Compose v2.0+
- Bash 4.0+

### 설치 및 실행

1. **저장소 클론**
```bash
git clone <repository-url>
cd redfin_infra
```

2. **환경 변수 설정**
```bash
cp .env.example .env
# .env 파일을 편집하여 필요한 환경 변수 설정
```

3. **인프라 스택 시작**
```bash
chmod +x setup_stack.sh
./setup_stack.sh
```

또는 직접 Docker Compose 실행:
```bash
docker compose up -d
```

4. **서비스 상태 확인**
```bash
docker compose ps
```

## 📁 디렉토리 구조

```
redfin_infra/
├── docker-compose.yaml      # 전체 인프라 스택 정의
├── setup_stack.sh           # 스택 초기화 및 시작 스크립트
├── check_net_infra.sh       # 네트워크 인프라 확인 스크립트
├── kibana_article_dashboard.sh  # Kibana 대시보드 설정 스크립트
├── nginx/                   # Nginx 설정
│   ├── nginx.conf          # 메인 Nginx 설정
│   ├── conf.d/             # HTTP/HTTPS 가상 호스트 설정
│   │   └── api-gateway.conf
│   ├── stream.d/           # TCP/UDP 스트림 프록시 설정
│   │   └── db-search.stream.conf
│   ├── certs/              # SSL/TLS 인증서 (Git 추적 제외)
│   └── logs/               # 액세스/에러 로그 (Git 추적 제외)
├── coredns/                # CoreDNS 설정
│   ├── Corefile            # DNS 서버 설정
│   └── zones/              # DNS 존 파일
│       ├── redfin.dev.db
│       └── 0.168.192.in-addr.arpa.db
└── README.md
```

## 🔧 주요 서비스 포트

| 서비스 | 포트 | 설명 |
|--------|------|------|
| Nginx HTTP | 80 | HTTP 트래픽 |
| Nginx HTTPS | 443 | HTTPS 트래픽 |
| CoreDNS UDP | 53 | DNS 쿼리 (UDP) |
| CoreDNS TCP | 1053 | DNS 쿼리 (TCP) |
| MongoDB | 27017 | MongoDB 연결 |
| Elasticsearch | 9200 | Elasticsearch HTTP API |
| Elasticsearch Transport | 9300 | Elasticsearch 노드 간 통신 |
| Kibana | 5601 | Kibana 웹 UI |
| Jenkins | 18081 | Jenkins 웹 UI |
| Mongo Express | 18082 | Mongo Express 웹 UI |
| Qdrant HTTP | 6333 | Qdrant HTTP API |
| Qdrant gRPC | 6334 | Qdrant gRPC API |

## 🌐 DNS 설정

### CoreDNS 개요

CoreDNS는 내부 네트워크에서 `.redfin.dev` 도메인을 관리합니다. Windows Host Namespace(Docker Desktop VM)에 바인딩되어 있어 WSL2의 127.0.0.1:53에는 리스너가 없어 connection refuse가 발생할 수 있습니다.

### DNS 테스트

**DNS 서버 내부(WSL2)에서:**
```bash
dig +short dns.redfin.dev @127.0.0.1
dig +short api.redfin.dev @127.0.0.1
dig +short rag.redfin.dev @127.0.0.1
```

**같은 서브넷의 다른 PC에서:**
```bash
dig +short rag.redfin.dev @192.168.0.123
dig -x 192.168.0.66 @192.168.0.123
```

### 네트워크 인프라 확인

```bash
chmod +x check_net_infra.sh
./check_net_infra.sh
```

## 🔐 보안

### 인증서 관리

- SSL/TLS 인증서는 `nginx/certs/` 디렉토리에 저장됩니다
- 인증서 파일(`*.pem`, `*.key`)은 `.gitignore`에 의해 Git 추적에서 제외됩니다
- 프로덕션 환경에서는 적절한 인증서를 배치해야 합니다

### 환경 변수

- `.env` 파일은 Git 추적에서 제외됩니다
- `.env.example` 파일을 참고하여 필요한 환경 변수를 설정하세요
- 민감한 정보(비밀번호, API 키 등)는 절대 커밋하지 마세요

## 📊 모니터링 및 로그

### Kibana 대시보드 설정

Article Recommender용 Kibana 대시보드를 자동으로 설정:
```bash
export KIBANA_URL=http://localhost:5601
chmod +x kibana_article_dashboard.sh
./kibana_article_dashboard.sh
```

### 로그 확인

**Nginx 로그:**
```bash
tail -f nginx/logs/access.log
tail -f nginx/logs/error.log
```

**컨테이너 로그:**
```bash
docker compose logs -f [service_name]
```

## 🛠️ 유지보수

### 서비스 재시작
```bash
docker compose restart [service_name]
```

### 서비스 중지
```bash
docker compose stop [service_name]
```

### 전체 스택 중지
```bash
docker compose down
```

### 데이터 볼륨 유지하며 중지
```bash
docker compose down
```

### 데이터 볼륨까지 완전 삭제
```bash
docker compose down -v
```

## 🔄 업데이트

### 이미지 업데이트
```bash
docker compose pull
docker compose up -d
```

### 설정 변경 후 재시작
```bash
docker compose up -d --force-recreate [service_name]
```

## 📝 환경 변수

주요 환경 변수는 `.env` 파일에서 관리됩니다. 예시:

```bash
# MongoDB
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=your_password
MONGO_APP_USERNAME=app_user
MONGO_APP_PASSWORD=app_password
MONGO_APP_DB=redfin_db

# Elasticsearch
ELASTIC_VERSION=8.14.0
ES_PORT=9200
ES_JAVA_HEAP=1g

# Kibana
KIBANA_PORT=5601

# Qdrant
QDRANT_HTTP_PORT=6333
QDRANT_GRPC_PORT=6334

# 기타
TZ=Asia/Seoul
```

## 🐛 문제 해결

### Elasticsearch 기동 실패
- 메모리 부족: `ES_JAVA_HEAP` 값을 줄이거나 호스트 메모리 확인
- 권한 문제: `ulimits` 설정 확인

### MongoDB 연결 실패
- 인증 정보 확인: `.env` 파일의 사용자명/비밀번호 확인
- 포트 충돌: 다른 MongoDB 인스턴스가 실행 중인지 확인

### DNS 쿼리 실패
- CoreDNS 컨테이너 상태 확인: `docker compose ps coredns`
- DNS 설정 확인: `coredns/Corefile` 및 존 파일 확인
- 네트워크 설정: `redfin_net` 네트워크 확인

## 📚 관련 문서

- [Docker Compose 공식 문서](https://docs.docker.com/compose/)
- [Nginx 문서](https://nginx.org/en/docs/)
- [CoreDNS 문서](https://coredns.io/manual/)
- [Elasticsearch 문서](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)

## 🤝 기여

이슈 및 개선 사항은 GitHub Issues를 통해 제출해주세요.

## 📄 라이선스

[라이선스 정보]
