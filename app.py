import json
import uuid

import socketio
import eventlet
from flask import Flask, render_template

sio = socketio.Server()
app = Flask(__name__)

class Clients:
    def __init__(self):
        self.users = []

    def update_user(self, user_sid, xpos, ypos, cmd):
        for index, obj in enumerate(self.users):
            if obj.sid == user_sid:
                obj.X = xpos
                obj.Y = ypos
                break

    def add_user(self, user):
        for index, obj in enumerate(self.users):
            if obj.sid == user.sid:
                del self.users[index]

        self.users.append(user)

    def delete_user(self, user_sid):
        for index, obj in enumerate(self.users):
            if obj.sid == user_sid:
                del self.users[index]
                break

    def get_users(self):
        return self.users

    def get_formatted_users(self):
        formatted_users = []
        for user in self.users:
            formatted_user = { 'sid': user.sid,
                               'X': user.X,
                               'Y': user.Y,
                             }
            formatted_users.append(formatted_user)
        return formatted_users


class Player:
    def __init__(self, sid):
        self.sid = sid
        self.X = 50
        self.Y = 50
        

CLIENTS = Clients()

@app.route('/')
def index():
    """Servce the client-side application."""
    return render_template('./index.html')

@app.route('/processing.js')
def processing():
    return render_template('./processing.js')

@app.route('/client.js')
def client():
    return render_template('./client.js')

@app.route('/engine.pde')
def engine():
    return render_template('./engine.pde')

@sio.on('connect')
def connect(sid, client_environ):
    print('Client connected to server: ', sid)
    sio.emit('onconnected', sid)
    
@sio.on('joined')
def joined(sid, client_sid):
    cSid = client_sid['client_sid']
    new_player = Player(cSid)
    CLIENTS.add_user(new_player)
    curr_users = CLIENTS.get_formatted_users()
    print "--User has been added--"
    sio.emit('send joined users', curr_users)

@sio.on('update user pos')
def update_user_pos(sid, data):
    user_sid = data[0].encode('ascii')
    user_xpos = data[1]
    user_ypos = data[2]
    user_cmd = data[3]
    
    CLIENTS.update_user(user_sid, user_xpos, user_ypos, user_cmd) 

@sio.on('update other users')
def update_other_users(sid):
    updated_users = CLIENTS.get_formatted_users()
    print "Updated user: ", updated_users
    sio.emit('send updated user pos', updated_users);

@sio.on('disconnect')
def disconnect(sid):
    print('Client disconnected: ', sid)
    CLIENTS.delete_user(sid)
    updated_users = CLIENTS.get_formatted_users()
    sio.emit('send updated users', updated_users)
    sio.disconnect(True)

if __name__ == '__main__':
    app = socketio.Middleware(sio, app)
    eventlet.wsgi.server(eventlet.listen(('', 8000)), app)

