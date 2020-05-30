rs.initiate(
   {
      _id: "rs0",
      members: [
         { _id: 0, host: "mongo0:27017", priority: 1000 },
         { _id: 1, host: "mongo1:27017", priority: 1 },
         { _id: 2, host: "mongo2:27017", priority: 0, arbiterOnly: true }
      ]
   }
);

cfg = rs.conf();
cfg.members[0].priority=1000;
cfg.members[1].priority=1;
cfg.members[2].priority=0;

rs.reconfig(cfg, {force: true});

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
