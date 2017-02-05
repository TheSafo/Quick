from flask import Flask, request
from flask_restful import Resource, Api
import psycopg2
import json
from datetime import datetime, date, time
from apns import APNs, Frame, Payload

app = Flask(__name__)
api = Api(app)

conn = psycopg2.connect(dbname="quickdata", user="Marko", host="localhost", port="6969")
cur = conn.cursor()

#cur.execute("INSERT INTO quickschemas.locations (id, lat, long, time) VALUES (%s, %s, %s, %s)", ('af89335822239426267392cde', 58, 57, datetime.now()))
#cur.execute("DELETE FROM quickschemas.locations")

@app.route("/")
def main():
    return "fuk u saf!"

class Profiles(Resource):
    def get(self):
    	data = request.get_json(force=True)
    	cur.execute("SELECT p.name FROM quickschemas.profiles p WHERE p.id=%s;", (data['id'],))
        return {data['id']: cur.fetchone()[0]}

    def post(self):
    	data = request.get_json(force=True)
        cur.execute("INSERT INTO quickschemas.profiles (id, name, token) VALUES (%s, %s, %s)", (data['id'], data['name'], data['token']))
        conn.commit()
        return 'success'
api.add_resource(Profiles, '/profiles')


class Locations(Resource):
    def get(self):
    	data = request.get_json(force=True)
    	cur.execute("SELECT l.lat, l.long FROM quickschemas.locations l WHERE l.id=%s ORDER BY l.time DESC LIMIT 1;", (data['id'],))
    	(lat, lon) = cur.fetchone()
        return {"lat": lat, "long": lon}

    def post(self):
    	data = request.get_json(force=True)
    	device_id = data['id']
    	lat = data['lat']
    	lon = data['long']
    	t = datetime.now()
        cur.execute("INSERT INTO quickschemas.locations (id, lat, long, time) VALUES (%s, %s, %s, %s)", (device_id, lat, lon, t))
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

		cur.execute("""INSERT INTO quickschemas.requests r (requester, price, description, fromlat, fromlon, tolat, tolon, details, time) 
												  VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id""", 
												  (requester, price, description, fromlat, fromlon, tolat, tolon, details, t))

		conn.commit()
		request_id = cur.fetchone()[0]
		payload = Payload(alert="Delivery Available!", custom=data)
		return request_id
api.add_resource(Request, '/requests')

if __name__ == "__main__":
    app.run(host= '0.0.0.0', port= 42069, debug = False)

cur.close()
conn.close()

#curl -X PUT -d '{"id":"123e4567-e89b-12d3-a456-426655440000","name":"Marko"}' http://0.0.0.0:42069/profile