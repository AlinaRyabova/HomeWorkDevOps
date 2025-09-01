{{- define "django-app.fullname" -}}
{{- printf "%s-%s" .Release.Name "django" -}}
{{- end }}