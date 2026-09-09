from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = b"OK\n"          # health check endpoint, polled by compose.yml healthcheck
            status = 200
        elif self.path == "/":
            body = b"Hello Team! Welcome to Week 4 GitHub Actions!\n"  # requested by make test
            status = 200
        else:
            body = b"Not Found\n"   # anything else is 404
            status = 404

        self.send_response(status)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 5000), Handler)  # listen on all interfaces, matches Dockerfile EXPOSE 5000
    print("Server listening on port 5000", flush=True)  # flush so container logs show it immediately
    server.serve_forever()
