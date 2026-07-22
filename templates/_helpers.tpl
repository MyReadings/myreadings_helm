{{- define "myreadings.labels" -}}
app.kubernetes.io/part-of: myreadings
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "myreadings.commonEnv" -}}
- name: POSTGRES_HOSTNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.postgres }}
      key: host
- name: POSTGRES_PORT_CONTAINER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.postgres }}
      key: port
- name: POSTGRES_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.postgres }}
      key: user
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.postgres }}
      key: password
- name: KEYCLOAK_HOSTNAME
  value: {{ .Values.keycloak.hostname | quote }}
- name: KEYCLOAK_PORT_CONTAINER
  value: {{ .Values.keycloak.port | quote }}
- name: KEYCLOAK_REALM
  value: {{ .Values.keycloak.realm | quote }}
- name: KEYCLOAK_CLIENT_ID
  value: {{ .Values.keycloak.clientId | quote }}
- name: KC_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.keycloak }}
      key: password
{{- if .Values.keycloak.tokenIssuer }}
- name: QUARKUS_OIDC_TOKEN_ISSUER
  value: {{ .Values.keycloak.tokenIssuer | quote }}
{{- end }}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ .Values.global.otelEndpoint | quote }}
- name: QUARKUS_OTEL_BSP_SCHEDULE_DELAY
  value: "1S"
- name: OTEL_METRIC_EXPORT_INTERVAL
  value: "5000"
{{- if not .Values.global.nativeMode }}
- name: JAVA_TOOL_OPTIONS
  value: "-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC -XX:+UseStringDeduplication -Xss512k"
{{- end }}
{{- end }}

{{- define "myreadings.rabbitmqEnv" -}}
- name: RABBITMQ_HOSTNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.rabbitmq }}
      key: host
- name: RABBITMQ_PORT_CONTAINER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.rabbitmq }}
      key: port
- name: RABBITMQ_APP_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.rabbitmq }}
      key: username
- name: RABBITMQ_APP_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secrets.rabbitmq }}
      key: password
- name: RABBITMQ_VHOST
  value: {{ .Values.rabbitmq.vhost | quote }}
- name: RABBITMQ_QUEUE_NAME
  value: {{ .Values.rabbitmq.queueName | quote }}
- name: RABBITMQ_BINDING_KEY
  value: {{ .Values.rabbitmq.bindingKey | quote }}
{{- end }}
