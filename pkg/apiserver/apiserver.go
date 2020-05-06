package apiserver

import (
	"context"
	"net/http"

	"github.com/golang/protobuf/ptypes/empty"
	"google.golang.org/grpc"

	"github.com/improbable-eng/grpc-web/go/grpcweb"

	epantyv1 "github.com/nmiculinic/ePantry/pkg/api/v1"
)

func NewAPIServer() http.Handler {
	grpcServer := grpc.NewServer()
	wrapperGRPCServer := grpcweb.WrapServer(grpcServer)
	epantyv1.RegisterEPantryServer(grpcServer, dummyAPIImpl{})
	return http.HandlerFunc(wrapperGRPCServer.ServeHTTP)
}

type dummyAPIImpl struct{}

func (d dummyAPIImpl) Version(context.Context, *empty.Empty) (*epantyv1.APIVersion, error) {
	return &epantyv1.APIVersion{
		Version: "I'm alive!!!",
	}, nil
}
