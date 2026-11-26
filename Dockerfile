# Puidutööstus MES prototype: static UI served by nginx on port 8080.
# nginx:alpine is multi-arch, so this builds on both x86_64 and
# Oracle Cloud Ampere (arm64) instances.
FROM nginx:1.27-alpine

# Replace the default site with one that listens on 8080
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/puit.conf

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
