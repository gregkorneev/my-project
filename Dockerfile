# --- Build stage ---
FROM ubuntu:22.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake g++ make git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Конфигурируем из подкаталога rpn_calculator, собираем ВСЁ и гоняем тесты
RUN cmake -S rpn_calculator -B build -DCMAKE_BUILD_TYPE=Release \
 && cmake --build build --parallel 2 \
 && ctest --output-on-failure --test-dir build

# --- Runtime stage ---
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6 && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/build/rpn_calculator /usr/local/bin/rpn_calculator
ENTRYPOINT ["/usr/local/bin/rpn_calculator"]
