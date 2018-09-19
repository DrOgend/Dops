FROM erlang:21

# Download the Erlang/OTP source
RUN mkdir /buildroot

RUN apt-get install -y wget
RUN apt-get install -y libssl-dev
RUN apt-get install -y openssl

#COPY _build/prod/rel/websocket_chat/websocket_chat-1.5.0.tar.gz /buildroot
#ADD include /buildroot  
#ADD Makefile /buildroot  
#ADD priv /buildroot  
#ADD rebar.config /buildroot  
#ADD rebar.lock /buildroot  
#ADD src /buildroot
#ADD _build /buildroot
COPY . /buildroot
WORKDIR /buildroot

#RUN tar -zxf websocket_chat-1.5.0.tar.gz
RUN rebar3 as prod tar


EXPOSE 8080 8080

CMD ["/buildroot/_build/prod/rel/websocket_chat/bin/websocket_chat-1.5.0", "foreground"]


