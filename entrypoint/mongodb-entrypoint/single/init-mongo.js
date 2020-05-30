rs.initiate();

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
