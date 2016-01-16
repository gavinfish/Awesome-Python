import SocketServer  
from SocketServer import StreamRequestHandler as SRH  
from time import ctime  
  
host = '127.0.0.1'  
port = 9999  
addr = (host,port)  
  
class Servers(SRH):  
    def handle(self):  
        print 'got connection from ',self.client_address  
        self.wfile.write('connection %s:%s at %s succeed!' % (host,port,ctime()))  
        while True:  
          try:
            data = self.request.recv(1024)
            if not data:   
                break  
            print data  
            print "RECV from ", self.client_address[0]  
            self.request.send(data)   
          except:
            print self.client_address,' disconneted' 
print 'server is running....'  
server = SocketServer.ThreadingTCPServer(addr,Servers)  
server.serve_forever()  
