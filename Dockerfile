FROM golang:alpine AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN apk add --update git make build-base

ENV USER=appuser
ENV UID=10001 

RUN adduser \    
    --disabled-password \    
    --gecos "" \    
    --home "/nonexistent" \    
    --shell "/sbin/nologin" \    
    --no-create-home \    
    --uid "${UID}" \    
    "${USER}"

WORKDIR /src/api/

COPY . .

RUN make install-deps
RUN make ci

RUN go build -o /go/bin/app main.go

FROM alpine
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --from=builder /go/bin/api /api
COPY --from=builder /src/api/migrations /migrations
COPY --from=builder /src/api/templates /templates


USER appuser:appuser

ENTRYPOINT [ "/app" ]
