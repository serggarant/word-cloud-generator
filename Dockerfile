FROM golang:1.13

RUN go get -u golang.org/x/lint/golint
RUN go get github.com/GeertJohan/go.rice/rice
RUN go get -u github.com/tools/godep
