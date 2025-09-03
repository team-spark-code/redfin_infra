#!/usr/bin/env bash
# kibana_fix_saved_search_and_dashboard.sh
# - 기존 Data View(title: article_recommender*) 찾기
# - Saved Search (indexRefName + references) 생성
# - Dashboard 재생성
# 사전: LENS 시각화(ID: lens-total-articles, lens-top-sources)가 존재한다고 가정
set -euo pipefail

# ==== 환경 변수 ====
: "${KIBANA_URL:?KIBANA_URL 가 비어 있습니다 (예: http://localhost:5601)}"
KIBANA_USER="${KIBANA_USER:-elastic}"
KIBANA_PASS="${KIBANA_PASS:-elastic}"

DATA_VIEW_TITLE_PATTERN="${DATA_VIEW_TITLE_PATTERN:-article_recommender*}"
DATA_VIEW_ID=""
LENS_TOTAL_ID="${LENS_TOTAL_ID:-lens-total-articles}"
LENS_TOPSRC_ID="${LENS_TOPSRC_ID:-lens-top-sources}"
SEARCH_ID="${SEARCH_ID:-search-articles}"
DASHBOARD_ID="${DASHBOARD_ID:-dashboard-article-recommender}"

auth=(-u "${KIBANA_USER}:${KIBANA_PASS}" -H 'kbn-xsrf: true' -H 'Content-Type: application/json')

need() { command -v "$1" >/dev/null 2>&1 || { echo "필요 명령어 없음: $1"; exit 1; }; }
need curl; need jq

echo "[0] Data View 탐색: ${DATA_VIEW_TITLE_PATTERN}"
# SavedObjects로 index-pattern 검색(가장 최신 1개 사용)
dv_find=$(curl -sS -X GET \
  "$KIBANA_URL/api/saved_objects/_find?type=index-pattern&search_fields=title&search=$(printf "%s" "$DATA_VIEW_TITLE_PATTERN" | sed 's/*/%2A/g')" \
  -H 'kbn-xsrf: true' "${auth[@]:0:2}" )
DATA_VIEW_ID=$(echo "$dv_find" | jq -r '.saved_objects[0].id // empty')

if [[ -z "${DATA_VIEW_ID}" ]]; then
  echo "Data View('${DATA_VIEW_TITLE_PATTERN}')를 찾지 못했습니다. Kibana에서 먼저 생성해 주세요."
  exit 1
fi
echo "  -> DATA_VIEW_ID: ${DATA_VIEW_ID}"

# 기존 Saved Search/대시보드 제거(있으면)
echo "[1] 기존 Saved Objects 제거(무시 가능)"
curl -sS -X DELETE "$KIBANA_URL/api/saved_objects/dashboard/${DASHBOARD_ID}" -H 'kbn-xsrf: true' "${auth[@]:0:2}" >/dev/null || true
curl -sS -X DELETE "$KIBANA_URL/api/saved_objects/search/${SEARCH_ID}"    -H 'kbn-xsrf: true' "${auth[@]:0:2}" >/dev/null || true

# Saved Search 생성 (중요: indexRefName + references 쌍)
echo "[2] Saved Search 생성"
REF_NAME="kibanaSavedObjectMeta.searchSourceJSON.index"
search_src=$(jq -nc --arg ref "$REF_NAME" '{query:{query:"",language:"kuery"},filter:[],indexRefName:$ref}')
search_payload=$(jq -nc --argjson ss "$search_src" --arg ref "$REF_NAME" --arg id "$DATA_VIEW_ID" '
{
  attributes:{
    title:"Articles Table",
    sort:[],
    columns:["title","source_domain","keywords","guid"],
    grid:{},
    hideChart:true,
    kibanaSavedObjectMeta:{searchSourceJSON:($ss|tojson)}
  },
  references:[{"type":"index-pattern","name":$ref,"id":$id}]
}')
curl -sS -X POST "$KIBANA_URL/api/saved_objects/search/${SEARCH_ID}" "${auth[@]}" -d "$search_payload" >/dev/null
echo "  -> Saved Search OK"

# 대시보드 생성
echo "[3] Dashboard 생성"
panels=$(jq -nc --arg lens1 "$LENS_TOTAL_ID" --arg lens2 "$LENS_TOPSRC_ID" --arg search "$SEARCH_ID" '
[
  {"panelIndex":"1","type":"lens","id":$lens1,"embeddableConfig":{},"gridData":{"x":0,"y":0,"w":12,"h":8,"i":"1"},"version":"8.0.0"},
  {"panelIndex":"2","type":"lens","id":$lens2,"embeddableConfig":{},"gridData":{"x":12,"y":0,"w":36,"h":16,"i":"2"},"version":"8.0.0"},
  {"panelIndex":"3","type":"search","id":$search,"embeddableConfig":{"columns":["title","source_domain","keywords","guid"]},"gridData":{"x":0,"y":8,"w":48,"h":16,"i":"3"},"version":"8.0.0"}
]')
dashboard_payload=$(jq -nc --arg panels "$(echo "$panels" | jq -c '.')" '
{ attributes:{
    title:"Article Recommender Overview",
    description:"Overview of article_recommender index",
    timeRestore:false,
    optionsJSON:"{\"useMargins\":true,\"syncColors\":false,\"syncCursor\":true,\"syncTooltips\":true}",
    panelsJSON:$panels
  }
}')
curl -sS -X POST "$KIBANA_URL/api/saved_objects/dashboard/${DASHBOARD_ID}" "${auth[@]}" -d "$dashboard_payload" >/dev/null
echo "  -> Dashboard OK"
echo "URL: ${KIBANA_URL}/app/dashboards#/view/${DASHBOARD_ID}"

