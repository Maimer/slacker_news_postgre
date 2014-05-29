function validateForm() {
  var result = true;
  if (document.submit.author.value == "") {
    document.getElementById("author_alert").innerHTML = "*Required";
    result = false;
  } else {
    document.getElementById("author_alert").innerHTML = "";
    result = true;
  };
  if (document.submit.title.value == "") {
    document.getElementById("title_alert").innerHTML = "*Required";
    result = false;
  } else {
    document.getElementById("title_alert").innerHTML = "";
    result = true;
  };
  if (document.submit.url.value == "") {
    document.getElementById("url_alert").innerHTML = "*Required";
    result = false;
  } else {
    document.getElementById("url_alert").innerHTML = "";
    result = true;
  };
  if (document.submit.desc.value == "" || document.submit.desc.value.length < 20) {
    document.getElementById("desc_alert").innerHTML = "*Must be more than 20 characters";
    result = false;
  } else {
    document.getElementById("desc_alert").innerHTML = "";
    result = true;
  };
  return result
}
