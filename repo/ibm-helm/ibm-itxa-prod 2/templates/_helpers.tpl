# Licensed Materials - Property of IBM
# IBM Transformation Extender Advanced (5724-Q23)
# (C) Copyright IBM Corp. 2021, 2022 All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "itxa-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "itxa-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "itxa-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create productID, product name and version for metering purpose.
*/}}
{{- define "itxa-chart.metering.prodname" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodname=.*" . -}}
{{- substr 9 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.nonprodname" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^nonprodname=.*" . -}}
{{- substr 12 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.prodid" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodid=.*" . -}}
{{- substr 7 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.nonprodid" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^nonprodid=.*" . -}}
{{- substr 10 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.prodversion" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodversion=.*" . -}}
{{- substr 12 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.prodmetric" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodmetric=.*" . -}}
{{- substr 11 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.prodchargedcontainers" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodchargedcontainers=.*" . -}}
{{- substr 22 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.prodcloudpakratio" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodcloudpakratio=.*" . -}}
{{- substr 18 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.cloudpakname" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^cloudpakname=.*" . -}}
{{- substr 13 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.cloudpakid" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^cloudpakid=.*" . -}}
{{- substr 11 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "itxa-chart.metering.cloudpakversion" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^cloudpakversion=.*" . -}}
{{- substr 16 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
name for the default ingress secret
*/}}
{{- define "itxa-chart.auto-ingress-secret" -}}
{{- include "itxa-chart.fullname" . | printf "%s-auto-ingress-secret" -}}
{{- end -}}



{{/*
create ingress paths based on context root
*/}}
{{- define "itxa-chart.ingress.paths.notes" -}}
{{- $varRoot := index . 0 }}
{{- $baseURL := index . 1 }}
{{- $contextList := index . 2 }}
{{- range $contextList }}
{{- $ctxRoot := .}}
{{- if $ctxRoot }}
{{ printf "echo %s : %s/%s" $ctxRoot $baseURL $ctxRoot | quote }}
{{- end }}
{{- end }}
{{- end -}}


{{/*
db schema defaulting logic
*/}}
{{- define "itxa-chart.dbschema" }}
{{- $varRoot := index . 0 }}
{{- $defaultVal := index . 1 }}
{{- if $varRoot.Values.global.database.schema }}
jdbcService.{{ $varRoot.Values.global.database.dbvendor | lower }}Pool.schema={{ $varRoot.Values.global.database.schema }}
si_config.DB_SCHEMA_OWNER={{ $varRoot.Values.global.database.schema }}
{{- else }}
jdbcService.{{ $varRoot.Values.global.database.dbvendor | lower }}Pool.schema={{ $defaultVal }}
si_config.DB_SCHEMA_OWNER={{ $defaultVal }}
{{- end }}
{{- end }}

{{/*
Check if License is accepted
*/}}
{{- define "itxa-chart.licenseValidate" -}}
{{- if .Values.global.license -}}
true
{{- end -}}
{{- end -}}

{{/*
Check if ITXA Admin User Secret is created
*/}}
{{- define "itxa-chart.userSecretValidate" -}}
{{- if .Values.itxauiserver.userSecret -}}
true
{{- end -}}
{{- end -}}

{{/*
Check if serviceAccountName is blank
*/}}
{{- define "itxa-chart.serviceAccountNameValidate" -}}
{{- if (empty .) -}}
{{- fail (printf "serviceAccountName is required and cannot be blank.") -}}
{{- end -}}
{{- end -}}

{{/*
Check if namespace is configured
*/}}
{{- define "itxa-chart.namespaceValidate" -}}
{{- if (empty .) -}}
{{- fail (printf "namespace is required and cannot be blank.") -}}
{{- end -}}
{{- end -}}