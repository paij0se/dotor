<script>
  window.document.body.classList.toggle(localStorage.getItem("theme"));
  import Button from "./Button.svelte";
  import dev from "./../config";
  let mainUrl = "";
  if (dev == true) {
    mainUrl = "http://127.0.0.1:8080/";
  } else {
    mainUrl = "https://dotor.elpanajose.repl.co/";
  }
  const admin = "4b84b15bff6ee5796152495a230e45e3d7e947d9";
  function unixTimeToDate(time) {
    const date = new Date(time * 1000);
    return date.toLocaleString();
  }
  //////////////////////////////////////////////////////////////////

  async function postCaptcha() {
    const input = document.getElementById("c-post").value;
    if (input == "") {
      alert("Tienes que rellenar el captcha!");
    } else {
      const res = await fetch(`${mainUrl}api/v1/post/captcha`, {
        method: "POST",
        body: JSON.stringify({ word: input }),
        headers: {
          "content-type": "application/json",
        },
      });
      const json = await res.json();
      console.log(json);
      if (json == "ok") {
        document.getElementById(
          "captcha-status"
        ).innerHTML = `<h1 style="color:green;">Correcto👍</h1>`;
      } else {
        document.getElementById(
          "captcha-status"
        ).innerHTML = `<h1 style="color:#B22222;">${json}</h1>`;
      }
    }
  }
  //////////////////////////////////////////////////////////////////

  async function captcha() {
    document.getElementById("captcha").src = "skull.gif";
    const res = await fetch(`${mainUrl}/api/v1/get/captcha`);
    const image = res.url;
    console.log(image);
    document.getElementById("captcha").src = image;
  }
  //////////////////////////////////////////////////////////////////

  function showPosts() {
    const res = fetch(`${mainUrl}api/v1/get`);
    res
      .then((a) => {
        return a.json();
      })
      .then((posts) => {
        for (let i = 0; i < posts.length; i++) {
          const postText = posts[i]["text"];
          if (posts[i]["user_id"] == admin) {
            //TODO  :skull:
            document.getElementById("posts").innerHTML += `
          
          <div id="response"></div>          
          <p>${unixTimeToDate(posts[i]["posted_at"])}</p>
          <details>
          <summary>More info</summary>
          <p>user: @${posts[i]["user_id"]}</p> 
          <p>post: ${posts[i]["post_id"]}</p> 
          </details>
          <p style="color:#660066;">[${
            posts[i]["name"]
          }]<img width="22" height="18" alt="admin🤓" src="https://raw.githubusercontent.com/paij0se/chapa.tk/main/public/nerd.png"></p>
        
          
          `;
            document.getElementById("posts").innerHTML += postText.replace(
              /</g,
              `<code id="o"><span><</span></code>`
            );
          } else {
            document.getElementById("posts").innerHTML += `
       
          <div id="response"></div>          
          <p>${unixTimeToDate(posts[i]["posted_at"])}</p>
          <details>
          <summary>More info</summary>
          <p>user: @${posts[i]["user_id"]}</p> 
          <p>post: ${posts[i]["post_id"]}</p> 
          </details>
          <p style="color:#efbbff;">[${posts[i]["name"]}]💀</p>       
        
          `;
            document.getElementById("posts").innerHTML += postText.replace(
              /</g,
              `<code id="o"><span><</span></code>`
            );
          }
        }
      });
  }
  showPosts();
  //////////////////////////////////////////////////////////////////
  async function doPost() {
    const inp = document.getElementById("n").value;
    var name = document.getElementById("name").value;
    if (name == 0) {
      name = "Anon";
    }
    if (inp == "") {
      alert("Tu texto está vacio!");
    } else {
      const res = await fetch(`${mainUrl}api/v1/post`, {
        method: "POST",
        body: JSON.stringify({ text: inp, name: name }),
        headers: {
          "content-type": "application/json",
        },
      });
      const json = await res.json();
      console.log(json);
      // cerror = captcha error
      if (json[0] == "cerror") {
        json.user_id = `<h1 style="color:#B22222;">${json[1]}</h1>`;
        json.posted_at = -15059544297;
      }
      if (json[0] == "error") {
        json.user_id = `
        <img width=20%; height=auto  ; src="nao.jpg">
        <h1 style="color:#B22222;">!Error¡ Solo 818 caracteres o menos</h1>
        <h1 style="color:#B22222;">${json[1]}</h1>
        `;
        json.posted_at = -15059544297;
      }
      // TODO: Mover esto a Svelte realmente...
      document.getElementById("response").innerHTML += ` 
      <p>${unixTimeToDate(json.posted_at)}</p>
      <p>${json.name}</p>
      <p>${json.user_id}</p>
      `;

      document.getElementById("response").innerHTML += json.text.replace(
        /</g,
        "<span><</span>"
      );
    }
  }
</script>

<main>
  <title>DotorChan</title>
  <h1>DotorChan</h1>
  <Button>Cambiar tema</Button>
  <p>
    <a href="https://github.com/paij0se/dotor"
      >Código fuente de está porquería.</a
    >
  </p>
  <br />

  <div id="captcha-container">
    <button type="button" id="pedir-c" on:click={captcha}>Pedir Captcha</button>
    <img id="waiting" alt="" />
    <!-- svelte-ignore a11y-missing-attribute -->
    <img id="captcha" />
    <div id="captcha-status" />
    <input placeholder="Captcha" id="c-post" />
    <button type="button" id="enviar-c" on:click={postCaptcha}
      >Enviar Captcha</button
    >
  </div>

  <br />

  <div id="form">
    <!--
      form
    -->
    <div id="form-input">
      <br />
      <input id="name" placeholder="Anónimo" />
      <br />
      <textarea rows="10" id="n" placeholder="¿Qué estas pensando?" />
      <button type="button" id="post-b" on:click={doPost}>Post</button>
      <div id="response-b" />
    </div>

    <h1>Posts</h1>
    <div id="posts" />
  </div>
</main>

<style>
  @import url("https://cdn.jsdelivr.net/npm/@xz/fonts@1/serve/cascadia-code.min.css");
  :global(body.dark-mode) {
    background-color: #1f1d27;
    color: #e0def4;
    transition: background-color 1s;
  }
  :global(body) {
    background-color: #fffaf3;
    color: #c4a7e7;
  }
  h1 {
    font-family: "Cascadia Code";
  }

  p {
    font-family: "Cascadia Code";
    font-weight: 600;
  }
</style>
