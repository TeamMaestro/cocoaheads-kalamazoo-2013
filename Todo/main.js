
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// responseUser <-- ID of user being asked
Parse.Cloud.define("requestFriend", function(request, response) {
    Parse.Cloud.useMasterKey();
    var fromUser = request.user;
	var query = new Parse.Query(Parse.User);
    query.get(request.params.responseUser,
    {
               success: function(toUser){
                      var Notification = Parse.Object.extend("Notification");
                      var note = new Notification();
                      note.set("type", 0);
                      note.set("sender", fromUser);
                      note.set("reciever", toUser);
                        note.save(null,{
                        success: function(note){
                                response.success("Friend Requested!");
                            }
                        });
              
               },
               error: function(object, error){
                    response.error(error.message + request.params.responseUser);
               }
    });
});

Parse.Cloud.define("addFriend", function(request, response) {
    Parse.Cloud.useMasterKey();
    var accepter = request.user;
    var query = new Parse.Query(Parse.User);
    query.get(request.params.responseUser, {
        success: function(requester){
                    var rel = requester.relation("friends");
                    var rel2 = accepter.relation("friends");
                    rel.add(accepter);
                    rel2.add(requester);
                    requester.save(null,{
                        success: function(requester){
                            accepter.save(null,{
                                success: function(requester){
                                response.success("FRIENDS!");
                            }
                        });
                    }
                });
            },
            error: function(object, error) {
                response.error(error);
        }
    });
});
