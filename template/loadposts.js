const pc = document.getElementById("post-container");
const lt = document.getElementById("loadtext");
const username = "!USER!";
const loadAmount = 5;
var postdata = !JSON!;
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
      lt.innerHTML = "Bottom"
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
        newPost += "<sub>" + postDate + "</sub>"

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