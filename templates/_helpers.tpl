{{/*
Expand the name of the chart.
*/}}
{{- define "haproxy-centos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "haproxy-centos.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "haproxy-centos.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "haproxy-centos.labels" -}}
helm.sh/chart: {{ include "haproxy-centos.chart" . }}
{{ include "haproxy-centos.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "haproxy-centos.selectorLabels" -}}
app.kubernetes.io/name: {{ include "haproxy-centos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "haproxy-centos.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "haproxy-centos.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the haproxy image
*/}}
{{- define "haproxy-centos.deployer.image" -}}
{{- $registryName := .Values.haproxy.image.registry -}}
{{- $repositoryName := .Values.haproxy.image.repository -}}
{{- $tag := .Values.haproxy.image.tag -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}

{{/*
Create the name of the ngnix image
*/}}
{{- define "haproxy-centos.nginxTest.image" -}}
{{- $registryName := .Values.nginxTest.image.registry -}}
{{- $repositoryName := .Values.nginxTest.image.repository -}}
{{- $tag := .Values.nginxTest.image.tag -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}
