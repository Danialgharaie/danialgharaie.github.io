#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
tmp_override="${tmp_dir}/comments-test-override.yml"
tmp_site="${tmp_dir}/site"
giscus_post="_posts/2020-01-01-comments-integration-giscus.md"
disqus_post="_posts/2020-01-02-comments-integration-disqus.md"

cleanup() {
  rm -f "${giscus_post}" "${disqus_post}"
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

cat >"${tmp_override}" <<'YAML'
giscus:
  repo: alshedivat/al-folio
  repo_id: R_kgDOExample
  category: Comments
  category_id: DIC_kwDOExample
YAML

cat >"${giscus_post}" <<'MD'
---
layout: post
title: "Comments Integration Giscus"
date: 2020-01-01
category: integration
giscus_comments: true
---

Temporary fixture used by the comments integration test.
MD

cat >"${disqus_post}" <<'MD'
---
layout: post
title: "Comments Integration Disqus"
date: 2020-01-02
category: integration
disqus_comments: true
---

Temporary fixture used by the comments integration test.
MD

bundle exec jekyll build --config "_config.yml,${tmp_override}" -d "${tmp_site}" >/dev/null

giscus_page="${tmp_site}/notebook/2020/comments-integration-giscus/index.html"
disqus_page="${tmp_site}/notebook/2020/comments-integration-disqus/index.html"

if [ ! -f "${giscus_page}" ]; then
  echo "giscus fixture page was not generated at ${giscus_page}" >&2
  exit 1
fi

if [ ! -f "${disqus_page}" ]; then
  echo "disqus fixture page was not generated at ${disqus_page}" >&2
  exit 1
fi

grep -q 'https://giscus.app/client.js' "${giscus_page}"
if grep -q 'giscus comments misconfigured' "${giscus_page}"; then
  echo "unexpected giscus misconfiguration warning in ${giscus_page}" >&2
  exit 1
fi

grep -q 'id="disqus_thread"' "${disqus_page}"
grep -q '.disqus.com/embed.js' "${disqus_page}"

echo "comments integration checks passed"
