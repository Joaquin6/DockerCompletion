$containerAll = { docker container ls --format '{{ .Names }}' --all }
$containerRunning = { docker container ls --format '{{ .Names }}' --filter 'status=running' }

$formatBasic = @("'{{json .}}'")

$logDriver = {
	'awslogs'
	'etwlogs'
	'fluentd'
	'gcplogs'
	'gelf'
	'journald'
	'json-file'
	'logentries'
	'none'
	'splunk'
	'syslog'
}

$networkAll = { docker network ls --format '{{ .Name }}' }

$repositoryWithTag = {
	docker image ls --format '{{ .Repository }}' | Sort-Object
	docker image ls --format '{{ .Repository }}:{{ .Tag }}' | Sort-Object
}

Register-Completer 'docker_--log-level' { 'debug', 'info', 'warn', 'error', 'fatal' }
Register-Completer 'docker_-l' (Get-Completer 'docker_--log-level')

Register-Completer 'docker_image_history' $repositoryWithTag
Register-Completer 'docker_image_inspect' $repositoryWithTag
Register-Completer 'docker_image_ls' $repositoryWithTag
Register-Completer 'docker_image_ls_--format' $formatBasic
Register-Completer 'docker_image_push' $repositoryWithTag
Register-Completer 'docker_image_rm' $repositoryWithTag
Register-Completer 'docker_image_save' $repositoryWithTag
Register-Completer 'docker_image_tag' $repositoryWithTag

Register-Completer 'docker_container_attach' $containerRunning
Register-Completer 'docker_container_create' $repositoryWithTag
Register-Completer 'docker_container_create_--log-driver' $logDriver
Register-Completer 'docker_container_diff' $containerAll
Register-Completer 'docker_container_exec' $containerRunning
Register-Completer 'docker_container_export' $containerAll
Register-Completer 'docker_container_inspect' $containerAll
Register-Completer 'docker_container_kill' $containerRunning
Register-Completer 'docker_container_logs' $containerAll
Register-Completer 'docker_container_ls_--format' $formatBasic
Register-Completer 'docker_container_pause' $containerRunning
Register-Completer 'docker_container_port' $containerAll
Register-Completer 'docker_container_rename' $containerAll
Register-Completer 'docker_container_restart' $containerAll
Register-Completer 'docker_container_rm' {
	Param($wordToComplete, $commandAst, $cursorPosition)

	$force = $false
	foreach ($ce in $commandAst.CommandElements) {
		if (@('--force', '-f') -contains $ce.Extent.Text) {
			$force = $true
			break
		}
	}

	if ($force) {
		docker container ls --format '{{ .Names }}' --all
	} else {
		docker container ls --format '{{ .Names }}' --filter 'status=created' --filter 'status=exited'
	}
}
Register-Completer 'docker_container_run' $repositoryWithTag
Register-Completer 'docker_container_run_--log-driver' $logDriver
Register-Completer 'docker_container_start' {
	docker container ls --format '{{ .Names }}' --filter 'status=created' --filter 'status=exited'
}
Register-Completer 'docker_container_stats' $containerRunning
Register-Completer 'docker_container_stop' $containerRunning
Register-Completer 'docker_container_top' $containerRunning
Register-Completer 'docker_container_wait' $containerAll

Register-Completer 'docker_network_inspect' $networkAll
Register-Completer 'docker_network_rm' { docker network ls --format '{{ .Name }}' --filter type=custom }

Register-Completer 'docker_service_create_--log-driver' $logDriver
Register-Completer 'docker_service_update_--log-driver' $logDriver
Register-Completer 'docker_service_update_--network-add' $networkAll
Register-Completer 'docker_service_update_--network-rm' $networkAll

Register-Completer 'docker_system_df_--format' $formatBasic
Register-Completer 'docker_system_events_--format' $formatBasic
Register-Completer 'docker_system_info_--format' $formatBasic

if ($env:DOCKER_HIDE_LEGACY_COMMANDS) {
	return
}

Register-Completer 'docker_attach' (Get-Completer 'docker_container_attach')
Register-Completer 'docker_create' (Get-Completer 'docker_container_create')
Register-Completer 'docker_create_--log-driver' (Get-Completer 'docker_container_create_--log-driver')
Register-Completer 'docker_diff' (Get-Completer 'docker_container_diff')
Register-Completer 'docker_events_--format' (Get-Completer 'docker_system_events_--format')
Register-Completer 'docker_exec' (Get-Completer 'docker_container_exec')
Register-Completer 'docker_export' (Get-Completer 'docker_container_export')
Register-Completer 'docker_history' (Get-Completer 'docker_image_history')
Register-Completer 'docker_images' (Get-Completer 'docker_image_ls')
Register-Completer 'docker_images_--format' (Get-Completer 'docker_image_ls_--format')
Register-Completer 'docker_info_--format' (Get-Completer 'docker_system_info_--format')
Register-Completer 'docker_kill' (Get-Completer 'docker_container_kill')
Register-Completer 'docker_logs' (Get-Completer 'docker_container_logs')
Register-Completer 'docker_pause' (Get-Completer 'docker_container_pause')
Register-Completer 'docker_port' (Get-Completer 'docker_container_port')
Register-Completer 'docker_ps_--format' (Get-Completer 'docker_container_ls_--format')
Register-Completer 'docker_push' (Get-Completer 'docker_image_push')
Register-Completer 'docker_rename' (Get-Completer 'docker_container_rename')
Register-Completer 'docker_rm' (Get-Completer 'docker_container_rm')
Register-Completer 'docker_rmi' (Get-Completer 'docker_image_rm')
Register-Completer 'docker_restart' (Get-Completer 'docker_container_restart')
Register-Completer 'docker_run' (Get-Completer 'docker_container_run')
Register-Completer 'docker_run_--log-driver' (Get-Completer 'docker_container_run_--log-driver')
Register-Completer 'docker_save' (Get-Completer 'docker_image_save')
Register-Completer 'docker_start' (Get-Completer 'docker_container_start')
Register-Completer 'docker_stats' (Get-Completer 'docker_container_stats')
Register-Completer 'docker_stop' (Get-Completer 'docker_container_stop')
Register-Completer 'docker_tag' (Get-Completer 'docker_image_tag')
Register-Completer 'docker_top' (Get-Completer 'docker_container_top')
Register-Completer 'docker_wait' (Get-Completer 'docker_container_wait')