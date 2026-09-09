from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            # 健康检查端点，compose.yml 的 healthcheck 会一直轮询这里
            body = b"OK\n"
            status = 200
        elif self.path == "/":
            # 首页，Makefile 的 make test 请求这里
            body = b"Hello Team! Welcome to Week 4 GitHub Actions!\n"
            status = 200
        else:
            # 其他任何路径一律 404
            body = b"Not Found\n"
            status = 404
        self.send_response(status)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    # 监听所有网卡的 5000 端口，配合 Dockerfile 的 EXPOSE 5000
    server = HTTPServer(("0.0.0.0", 5000), Handler)
    # flush=True 避免容器日志被缓冲、迟迟看不到输出
    print("Server listening on port 5000", flush=True)
    server.serve_forever()
