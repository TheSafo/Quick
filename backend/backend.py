from flask import Flask, request
from flask_restful import Resource, Api
import psycopg2
import json
from datetime import datetime, date, time
from apns import APNs, Frame, Payload
import os

app = Flask(__name__)
api = Api(app)
PATH = os.path.dirname(os.path.abspath(__file__))
apns = APNs(use_sandbox=True, cert_file=PATH+'/cert.pem')#, key_file=PATH+'/key.pem')

conn = psycopg2.connect(dbname="quickdata", user="Marko", host="localhost", port="6969")
cur = conn.cursor()
# cur.execute("ALTER TABLE quickschemas.locations ADD COLUMN pt geography(POINT,4326) NOT NULL")
# cur.execute("INSERT INTO quickschemas.locations (id, lat, long, time) VALUES (%s, %s, %s, %s)", ('af89335822239426267392cde', 58, 57, datetime.now()))
# cur.execute("DELETE FROM quickschemas.locations")
# conn.commit()

@app.route("/")
def main():
    return "youre not sleeping until this is done!"

class Profiles(Resource):
    def get(self):
        data = request.get_json(force=True)
        cur.execute("SELECT p.name FROM quickschemas.profiles p WHERE p.id=%s;", (data['id'],))
        return {data['id']: cur.fetchone()[0]}

    def post(self):
        data = request.get_json(force=True)
        cur.execute("INSERT INTO quickschemas.profiles (id, name, token, phone) VALUES (%s, %s, %s, %s) ON CONFLICT (id) DO UPDATE SET name=%s, token=%s, phone=%s",
                   (data['id'], data['name'], data['token'], data['phone'], data['name'], data['token'], data['phone']))
        conn.commit()
        return 'success'

api.add_resource(Profiles, '/profiles')


class Locations(Resource):
    # def get(self):
    #   data = request.get_json(force=True)
    #   cur.execute("SELECT l.lat, l.long FROM quickschemas.locations l WHERE l.id=%s ORDER BY l.time DESC LIMIT 1;", (data['id'],))
    #   (lat, lon) = cur.fetchone()
    #     return {"lat": lat, "long": lon}

    def post(self):
        data = request.get_json(force=True)
        device_id = data['id']
        lat = data['lat']
        lon = data['long']
        t = datetime.now()
        #4326 is the srid corresponding to lat long coords
        cur.execute("""INSERT INTO quickschemas.locations (id, time, pt) VALUES (%s, %s,
            ST_SetSRID(ST_Point(%s, %s),4326)::geography)""", (device_id, t, lon, lat))
        conn.commit()
        return "success"

api.add_resource(Locations, '/locations')

class Request(Resource):
    def post(self):
        data = request.get_json(force=True)
        requester = data['requester']
        price = data['price']
        description = data['description']
        fromlat = data['fromlat']
        fromlon = data['fromlon']
        tolat = data['tolat']
        tolon = data['tolon']
        details = data['details']
        t = datetime.now()
        tokens = []
        cur.execute("""INSERT INTO quickschemas.requests (requester, price, description, fromlat, fromlon, tolat, tolon, details, time) 
                                                  VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id""", 
                                                  (requester, price, description, fromlat, fromlon, tolat, tolon, details, t))
        conn.commit()
        request_id = cur.fetchone()[0]
        cur.execute("""SELECT DISTINCT l.id AS id FROM quickschemas.locations l WHERE l.time BETWEEN %s - (20 * interval '1 minute') AND %s
                                              AND ST_DWithin(l.pt, ST_SetSRID(ST_Point(%s, %s),4326)::geography, 250)
                                              AND l.id!=%s""", (t, t, fromlon, fromlat, requester))
        for dev_id in cur.fetchall():
            # cur.execute("""SELECT COUNT(l2.id) FILTER (WHERE ST_DWithin(l2.pt, ST_SetSRID(ST_Point(%s, %s),4326)::geography, 250)
            #                                           AND to_char(l.time, 'DD:MM:YY')=to_char(l2.time, 'DD:MM:YY')), COUNT(l.id)
            #                     FROM quickschemas.locations l, quickschemas.locations l2 WHERE (EXTRACT(DOW FROM TIMESTAMP l.time)=EXTRACT(DOW FROM TIMESTAMP %s)
            #                     OR EXTRACT(DOW FROM TIMESTAMP l.time)+1=EXTRACT(DOW FROM TIMESTAMP %s))
            #                     AND ((EXTRACT(HOUR FROM TIMESTAMP %s)*60+EXTRACT(MINUTE FROM TIMESTAMP %s))
            #                     - (EXTRACT(HOUR FROM TIMESTAMP l.time)*60+EXTRACT(MINUTE FROM TIMESTAMP l.time)
            #                     BETWEEN 0 AND 60 
            #                     OR (EXTRACT(HOUR FROM TIMESTAMP %s)*60+EXTRACT(MINUTE FROM TIMESTAMP %s))
            #                     - (EXTRACT(HOUR FROM TIMESTAMP l.time)*60+EXTRACT(MINUTE FROM TIMESTAMP l.time)
            #                     BETWEEN 1380 AND 1439)
            #                     AND l.id=%s""", (tolon, tolat, t, t, t, t, t, t, dev_id))
            # dev_counts = cur.fetchone()
            # if dev_counts[1] < 3 or dev_counts[0]/dev_counts[1] > 0.5:
            #     cur.execute("SELECT p.token FROM quickschemas.profiles p WHERE p.id = %s", (dev_id, ))
            #     tokens.append(cur.fetchone()[0])
            cur.execute("SELECT p.token FROM quickschemas.profiles p WHERE p.id = %s", (dev_id, ))
            tokens.append(cur.fetchone()[0])
        push_data = {'notification_type':2, 'data': data, 'id': request_id}
        payload = Payload(alert="En Route Delivery Available!", custom=push_data)
        for req_token in tokens:
            apns.gateway_server.send_notification(req_token, payload)
        return request_id

    def get(self):
        data = request.args
        device_id = data['id']
        lat = data['lat']
        lon = data['lon']
        check_time = datetime.now()
        cur.execute("""SELECT r.price, r.description, r.fromlon, r.fromlat, r.tolon, r.tolat, r.requester, r.accepter, 
                              to_char(r.time, 'HH12:MI') AS time, r.details, r.id 
                              FROM quickschemas.requests r WHERE ST_DWithin(ST_SetSRID(ST_Point(r.fromlon, r.fromlat),4326)::geography, 
                              ST_SetSRID(ST_Point(%s, %s),4326)::geography, 500) 
                              AND r.accepter IS NULL
                              AND r.requester!=%s
                              AND r.time BETWEEN %s - (3000 * interval '1 minute') AND %s
                              ORDER BY ST_Distance(ST_SetSRID(ST_Point(r.fromlon, r.fromlat),4326)::geography,
                              ST_SetSRID(ST_Point(%s, %s),4326)::geography) ASC""", (lon, lat, device_id, check_time, check_time, lon, lat))
        return {'results': [dict(zip([column[0] for column in cur.description], row)) for row in cur.fetchall()]}

    def put(self):
        data = request.get_json(force=True)
        request_id = data['id']
        accepter = data['accepter']
        cur.execute("""UPDATE quickschemas.requests SET accepter=%s WHERE id=%s""", (accepter, request_id))
        push_data = {'id':request_id, 'notification_type':1, 'accepter':accepter}
        cur.execute("SELECT p.name, p.phone FROM quickschemas.profiles p WHERE p.id=%s", (accepter, ))
        (push_data['name'], push_data['phone']) = cur.fetchone()
        payload = Payload(alert="Order Accepted!", custom=push_data)
        cur.execute("SELECT p.token, p.id FROM quickschemas.profiles p, quickschemas.requests r WHERE r.id=%s AND r.requester=p.id", (request_id, ))
        (req_token, req_id) = cur.fetchone()
        apns.gateway_server.send_notification(req_token, payload)
        cur.execute("SELECT p.phone, p.name FROM quickschemas.profiles p WHERE p.id=%s", (req_id,))
        req_info = cur.fetchone()
        return {'phone': req_info[0], 'name': req_info[1]}

api.add_resource(Request, '/requests')

if __name__ == "__main__":
    app.run(host= '0.0.0.0', port= 42069, debug = False)

cur.close()
conn.close()

#curl -X PUT -d '{"id":"123e4567-e89b-12d3-a456-426655440000","name":"Marko"}' http://0.0.0.0:42069/profile