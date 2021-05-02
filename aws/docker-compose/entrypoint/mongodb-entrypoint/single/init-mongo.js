// single node init default rs config
rs.initiate();

// single node init
rs.initiate(
   {
      _id: "rs0",
      members: [
         { _id: 0, host: "mongo0:27017", priority: 1000 }
      ]
   }
);

db.createUser(
        {
            user: "user",
            pwd: "user",
            roles: [
                {
                    role: "readWrite",
                    db: "events"
                }
            ]
        }
);

// in case of OTHER replica state:
rs.reconfig(
   {
      _id: "rs0",
      members: [
         { _id: 0, host: "mongo0:27017", priority: 1000 }
      ]
   }, {force: true}
);
