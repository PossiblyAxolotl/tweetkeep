const pc = document.getElementById("post-container");
const lt = document.getElementById("loadtext");
const username = "PossiblyAxolotl";
const loadAmount = 5;
var postdata = [
  {"tweet":{
    "in_reply_to_status_id":"1772113298961338698",
    "full_text":"Wow what a neat idea! That's so smart and cool.",
    "created_at":"Mon Mar 25 4:32:00"
  }},
  {"tweet":{
    "full_text":"Bro why's my banner all screwed up like that come on man",
    "created_at":"Sun Mar 24 2:01:59"
  }},
  {"tweet":{
    "full_text":"NARRATOR:\
    (Black screen with text; The sound of buzzing bees can be heard)\
    According to all known laws\
    of aviation,\
    there is no way a bee\
    should be able to fly.\
    Its wings are too small to get\
    its fat little body off the ground.\
    The bee, of course, flies anyway\
    because bees don't care\
    what humans think is impossible.",
    "created_at":"Fri Mar 22 15:07:20"
  }},
  {"tweet":{
  "full_text":"Hello, World!",
  "created_at":"Fri Mar 22 15:06:20"
}},
{"tweet":{
  "full_text":"Bro that video sucked. You should go retire. Look, even I can make a better video",
  "created_at":"Fri Mar 22 15:02:14",
  "in_reply_to_status_id":"1739757427573346322",
  "med":["mean.mp4"]
}},
{"tweet":{
  "full_text":"This is an example post. I am not real. Wake up.",
  "created_at":"Thu Mar 21 8:23:00"
}},
{"tweet":{
  "full_text":"Wow, look at this cool picture I found!",
  "created_at":"Wed Mar 20 23:12:43",
  "med":[
    "coolimg.png"
  ]
}},
{"tweet":{
  "full_text":"I'm not creative enough to keep coming up with ideas of what to write but if you get to the bottom it should load more, like infinite scrolling type-a thing. Anyway, consider checking out https://tweetkeep.possiblyaxolotl.com if you wanna leave twitter but still want an archive of your stuff, that's all. Bye :)",
  "created_at":"Tues Mar 19 12:12:12",
}}
];
var totalposts = postdata.length;
var re = /(?:\.([^.]+))?$/;

const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const mode = urlParams.get("mode");

function urlify(text) { /* https://stackoverflow.com/questions/1500260/detect-urls-in-text-with-javascript */
  var urlRegex = /(https?:\/\/[^\s]+)/g;
  return text.replace(urlRegex, function(url) {
    return '<a href="' + url + '">' + url + '</a>';
  })
}

if (mode == "posts") {
  document.getElementById("postbutton").disabled = true;
} else if (mode =="replies") {
  document.getElementById("repliesbutton").disabled = true;
} else {
  document.getElementById("allbutton").disabled = true;
}

function loadPosts(custAmnt = 7) {
  let postsToLoad = custAmnt;
  if (totalposts < custAmnt) {
      postsToLoad = totalposts;
      lt.innerHTML = "Bottom of page"
  }

  while (postsToLoad > 0) {
      let post = postdata.shift().tweet;

      if ("in_reply_to_status_id" in post != true && mode != "replies") {
        let newPost = "<hr><p>" + urlify(post.full_text) + '</p>';
        let postDate = post.created_at.split(" +")[0];

        if ("med" in post) {
          newPost += "<div class='mediabox'>"
          post.med.forEach((media) => {
            var extension = re.exec(media)[1]
            
            if (extension != "mp4") {
              newPost += "<a target='_blank' href='media/" + media + "'><img src='media/" + media +"'></a>";
            } else {
              newPost += "<video controls><source src='media/" + media + "'>Your browser does not support the video tag.</video>"
            }
            
          })
          newPost += "</div>"
        }

        newPost += "<sub>" + postDate + "</sub>"

        pc.innerHTML += newPost;
        postsToLoad--;
        totalposts--;
      }

      if ("in_reply_to_status_id" in post && mode != "posts") {
        let newPost = "<hr><p>" + urlify(post.full_text) + '</p>';
        let postDate = post.created_at.split(" +")[0];

        if ("med" in post) {
          newPost += "<div class='mediabox'>"
          post.med.forEach((media) => {
            var extension = re.exec(media)[1]
            
            if (extension != "mp4") {
              newPost += "<a target='_blank' href='media/" + media + "'><img src='media/" + media +"'></a>";
            } else {
              newPost += "<video controls><source src='media/" + media + "'>Your browser does not support the video tag.</video>"
            }
            
          })
          newPost += "</div>"
        }
        newPost += '<a href="https://www.twitter.com/' + username + "/status/" + post.in_reply_to_status_id + '">In reply to...</a>'
        newPost += "<br><sub>" + postDate + "</sub>"

        pc.innerHTML += newPost;
        postsToLoad--;
        totalposts--;
      }
  }
}

window.onscroll = function(ev) {
    if ((window.innerHeight + Math.round(window.scrollY)) >= document.body.offsetHeight) {
        loadPosts();
    }
};

loadPosts(10);