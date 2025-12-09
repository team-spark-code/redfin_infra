# Redfin Infrastructure

Redfin 프로젝트 전반 인프라 관리 및 배포 자동화를 담당하는 저장소입니다.

## 📋 개요

이 저장소는 Redfin 프로젝트의 핵심 인프라 서비스들을 Docker Compose로 관리합니다.<br>
API 게이트웨이, DNS 서버, 데이터베이스, 검색 엔진, CI/CD 등<br>
개발 및 운영에 필요한 모든 인프라 컴포넌트를 포함합니다.

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

## 📚 문서

상세한 문서는 [`docs/`](./docs/) 디렉토리에서 확인할 수 있습니다:

- [🏗️ 아키텍처](./docs/architecture.md) - 서비스 구성 및 포트 정보
- [⚙️ 설치 및 설정](./docs/installation.md) - 상세 설치 가이드 및 디렉토리 구조
- [🌐 DNS 설정](./docs/dns.md) - CoreDNS 설정 및 테스트 방법
- [🔐 보안](./docs/security.md) - 인증서 관리 및 보안 모범 사례
- [📊 모니터링 및 로그](./docs/monitoring.md) - Kibana 대시보드 및 로그 확인
- [🛠️ 유지보수](./docs/maintenance.md) - 서비스 관리 및 업데이트
- [🐛 문제 해결](./docs/troubleshooting.md) - 일반적인 문제 및 해결 방법
- [📝 환경 변수](./docs/environment-variables.md) - 환경 변수 설정 가이드

## 🔧 주요 서비스

- **Nginx**: 리버스 프록시, API 게이트웨이
- **CoreDNS**: 내부 DNS 서버
- **MongoDB**: 문서 기반 데이터베이스
- **Elasticsearch**: 검색 및 분석 엔진
- **Kibana**: Elasticsearch 시각화
- **Jenkins**: CI/CD 파이프라인
- **Qdrant**: 벡터 데이터베이스

## 📚 관련 문서

- [Docker Compose 공식 문서](https://docs.docker.com/compose/)
- [Nginx 문서](https://nginx.org/en/docs/)
- [CoreDNS 문서](https://coredns.io/manual/)
- [Elasticsearch 문서](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)

## 🤝 기여

이슈 및 개선 사항은 GitHub Issues를 통해 제출해주세요.

## 📄 라이선스

MIT License
