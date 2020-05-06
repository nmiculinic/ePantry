package main

import (
	"net/http"

	"github.com/gorilla/handlers"
	"github.com/spf13/cobra"
	"go.uber.org/zap"

	"github.com/nmiculinic/ePantry/pkg/apiserver"
)

type flags struct {
	addr              string
	TLSCertFile       string
	TLSPrivateKeyFile string
}

func main() {
	log, err := zap.NewDevelopment()
	if err != nil {
		panic(err)
	}
	defer log.Sync()
	flags := &flags{}
	cmd := &cobra.Command{
		Args:  cobra.NoArgs,
		Use:   "apiserver",
		Short: "KubeCarrier API server",
		RunE: func(cmd *cobra.Command, args []string) error {
			return runE(flags, log)
		},
	}
	cmd.Flags().StringVar(&flags.addr, "address", "0.0.0.0:8090", "Address to bind this API server on.")
	cmd.Flags().StringVar(&flags.TLSCertFile, "tls-cert-file", "", "File containing the default x509 Certificate for HTTPS. If not provided no TLS security shall be enabled")
	cmd.Flags().StringVar(&flags.TLSPrivateKeyFile, "tls-private-key-file", "", "File containing the default x509 private key matching --tls-cert-file.")
	if err := cmd.Execute(); err != nil {
		panic(err)
	}
}

func runE(flags *flags, logger *zap.Logger) error {
	log := logger.Sugar()
	handler := apiserver.NewAPIServer()
	handler = handlers.CORS(
		handlers.AllowedHeaders([]string{
			"X-Requested-With",
			"Content-Type",
			"Authorization",
			"X-grpc-web",
			"X-user-agent",
		}),
		handlers.AllowedMethods([]string{"GET", "POST"}),
		handlers.AllowedOrigins([]string{"*"}),
	)(handler)
	server := http.Server{
		Handler: handler,
		Addr:    flags.addr,
	}

	log.Info("serving serving API-server", "addr", flags.addr)
	if flags.TLSCertFile == "" {
		log.Info("No TLS cert file defined, skipping TLS setup")
		return server.ListenAndServe()
	} else {
		log.Info("using provided TLS cert/key")
		return server.ListenAndServeTLS(flags.TLSCertFile, flags.TLSPrivateKeyFile)
	}
}
