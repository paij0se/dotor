# Dotor in development.

![image](https://user-images.githubusercontent.com/69026987/204405044-08c2500f-0044-4e26-af77-30fbc0ac2edf.png)

# Prerequisites

Elixir >= 1.14

Erlang OTP >= 25


# Deployment

Set the env variables in your .zshrc or .bashrc

```
export MONGO_URI=
export MONGO_PASS=
export MONGO_USER=
export CAPTCHA_URI=
```

Install the dependencies

`$ mix deps.get`

Run the api 

`$ mix run --no-halt`

visit http://127.0.0.1:8080

# TODO

- [x] Captcha
- [x] rate-limit
- [ ] boards
- [ ] better fronted
