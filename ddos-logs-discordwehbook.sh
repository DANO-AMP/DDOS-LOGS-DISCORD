clear
echo -e "\033[32;5mAttack Logs \033[0m"
interface=vmbr0
dumpdir=/root
capturefile=/root/output.txt
 url='https://discord.com/api/webhooks/825340952994512920/SRfwBt-VoLjluRL3TFKTQE0kjSAs-XuLhn0hVjF9JVurS5LY-XC1tTUdPyiZsFor_-K2' ## Change this to your Webhook URL
while /bin/true; do
  pkt_old=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  sleep 1
  pkt_new=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  pkt=$(($pkt_new - $pkt_old))
  echo -ne "\r$pkt packets/s\033[0K"
  sleep 1
  if [ $pkt -gt 45000 ]; then ## Attack alert will display after incoming traffic reach 2500 PPS
    echo "Attack Detected"
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
      	"inline": true,
        "title": "Attack detected | XYZ  CLOUD",
        "username": "Attack Alerts",
        "color": 15158332,
         "thumbnail": {
          "url": "https://cdn.discordapp.com/attachments/809059844937744397/825341599629180938/photos_host.png"
        },
         "footer": {
            "text": "XYZ-CLOUD",
            "icon_url": "https://cdn.discordapp.com/attachments/809059844937744397/825341599629180938/photos_host.png"
          },
    
         "fields": [
      {
        "name": "**Datacenter**",
        "value": "NULL",
        "inline": true
      },
      {
        "name": "**Status**",
        "value": "Enter into mitigation",
        "inline": true
      },
      {
        "name": "**Packets**",
        "value": "'$pkt'",
        "inline": true
      }
    ]
      }]
    }' $url
    echo "Attack Detected"
    sleep $((50%400))  ## The "Attack no longer detected" alert will display in 220 seconds
    ## echo "Packets Dunped"
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
      	"inline": true,
        "title": "Attack not detected anymore | XYZ  CLOUD",
        "username": "Attack Detection",
        "color": 3066993,
         "thumbnail": {
          "url": "https://cdn.discordapp.com/attachments/809059844937744397/825341599629180938/photos_host.png"
        },
         "footer": {
            "text": "XYZ CLOUD",
            "icon_url": "https://cdn.discordapp.com/attachments/809059844937744397/825341599629180938/photos_host.png"
          },    
          
         "fields": [
      {
        "name": "**Datacenter**",
        "value": "NULLED",
        "inline": true
      },
      {
        "name": "**Status**",
        "value": "Leaving mitigation",
        "inline": true
      },
      {
        "name": "**Packets**",
        "value": "'$pkt'",
        "inline": true
      }
    ]
      }]
    }' $url
  fi
done