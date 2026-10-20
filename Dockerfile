# Multi-stage Dockerfile for AI Analytics Pipeline Runner
FROM postgres:15-alpine AS runner

RUN apk add --no-cache bash curl

WORKDIR /workspace

# Copy pipeline assets
COPY sql/ /workspace/sql/
COPY scripts/ /workspace/scripts/
COPY examples/ /workspace/examples/

RUN chmod +x /workspace/scripts/*.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/workspace/scripts/run_pipeline.sh"]
