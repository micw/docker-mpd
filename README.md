# Dockerized MPD

This docker image is similar to https://hub.docker.com/r/vimagick/mpd/ but it is based on debian slim because alpine has DNS issues on kubernetes with some streaming servers.

To deploy on kubernetes, you can use this yaml as base:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mpd
  labels:
    app.kubernetes.io/name: mpd
spec:
  replicas: 
  selector:
    matchLabels:
      app.kubernetes.io/name: mpd
  template:
    metadata:
      labels:
        app.kubernetes.io/name: mpd
    spec:
      initContainers:
        - name: mkdirs
          image: "micwy/mpd:v1.0"
          imagePullPolicy: Always
          command:
            - /bin/sh
            - -c
            - |
              mkdir -p /var/lib/mpd/music /var/lib/mpd/playlists
              chown mpd /var/lib/mpd -R
          volumeMounts:
            - name: mpd
              mountPath: /var/lib/mpd
      containers:
        - name: mpd
          image: "micwy/mpd:v1.0"
          imagePullPolicy: Always
          securityContext:
            privileged: true
          ports:
            - name: mpd
              containerPort: 6600
              hostPort: 6600
              protocol: TCP
          volumeMounts:
            - name: devsnd
              mountPath: /dev/snd
            - name: mpd
              mountPath: /var/lib/mpd
      volumes:
        - name: devsnd
          hostPath:
            path: /dev/snd
            type: Directory
        - name: mpd
          hostPath:
            path: /data/k8s/mpd
            type: DirectoryOrCreate
  strategy:
    type: Recreate
```