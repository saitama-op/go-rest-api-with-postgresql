# ---- Build stage ----
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Install git (needed for dependencies sometimes)
RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o app .

# ---- Runtime stage ----
FROM alpine:3.19

WORKDIR /app

# Add certificates (important for DB connections)
RUN apk add --no-cache ca-certificates

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
