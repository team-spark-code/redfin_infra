# 아키텍처

## 포함된 서비스

Redfin 인프라 스택은 다음과 같은 서비스들로 구성됩니다:

- **Nginx**: 리버스 프록시, API 게이트웨이, SSL/TLS 종료
- **CoreDNS**: 내부 DNS 서버 (`.redfin.dev` 도메인 관리)
- **MongoDB**: 문서 기반 데이터베이스
- **Mongo Express**: MongoDB 웹 관리 UI
- **Elasticsearch**: 검색 및 분석 엔진
- **Kibana**: Elasticsearch 시각화 및 대시보드
- **Jenkins**: CI/CD 파이프라인
- **Qdrant**: 벡터 데이터베이스 (RAG 시스템용)

## 주요 서비스 포트

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

## 네트워크 구조

모든 서비스는 `redfin_net`이라는 Docker 브리지 네트워크를 통해 통신합니다. 이를 통해 서비스 간 내부 통신이 가능하며, 외부에서는 Nginx를 통해서만 접근할 수 있습니다.

