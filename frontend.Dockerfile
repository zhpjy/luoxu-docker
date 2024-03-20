FROM node:lts-alpine AS builder-image

RUN apk fix && \
    apk --no-cache --update add git 

ENV BACKEND_URL="http://example.com"

WORKDIR /build
RUN git clone --depth 1 -b master https://github.com/lilydjwg/luoxu-web /build && \
	sed -Ei 's#(const LUOXU_URL = ")[^"]+(/luoxu")#\1${DOMAIN}\2#' /build/src/App.svelte && \
    npm install && \
	npm run build 

FROM danjellz/http-server AS runner-image

COPY --from=builder-image /build/dist /public

CMD ["http-server", "-p", "80","--proxy","http://luoxu-backend:9008"]

