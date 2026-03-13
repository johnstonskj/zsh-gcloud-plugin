# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name gcloud
# @brief Set up Google Cloud SDK environment
# @repository https://github.com/johnstonskj/zsh-gcloud-plugin
# @version 0.1.0
# @license MIT AND Apache-2.0
#
# @description
#
# Long description TBD.
#
# ### Public Variables
#
# * **GCLOUD_SDK_HOME**: The root directory for the SDK installation.
#

###################################################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

@zplugins_declare_plugin_dependencies mise brew shlog

#
# @description
#
# Set the environment for the Google Cloud SDK and CLI.
#
# @noargs
#
# @exitcode 0 Success.
# @exitcode 1 Directory or file not found in cask.
# @exitcode 2 Cask not installed in Homebrew.
#
# @set GCLOUD_SDK_HOME path The root directory for the SDK installation.
#
gcloud_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Save and export any additional environment variables here.
    @zplugins_envvar_save gcloud GCLOUD_SDK_HOME

    local cask_path="$(homebrew_cask_prefix gcloud-cli)"

    if [[ -n "${cask_path}" ]]; then
        typeset -g GCLOUD_SDK_HOME="${cask_path}/latest/google-cloud-sdk"

        if [[ -d "${GCLOUD_SDK_HOME}/bin" ]]; then
            @zplugins_add_to_path gcloud "${GCLOUD_SDK_HOME}/bin"
        else
            log_error "zsh-gcloud: no 'bin' directory found in gcloud-cli cask."
            return 1
        fi

        if [[ -f "${GCLOUD_SDK_HOME}/completion.zsh.inc" ]]; then
            source "${GCLOUD_SDK_HOME}/completion.zsh.inc"
        else
            log_warning "zsh-gcloud: no 'completion.zsh.inc' found found in gcloud-cli cask."
        fi
        return 0
    else
        log_error "zsh-gcloud: the Homebrew cask 'gcloud-cli' does not seem to be installed."
        return 2
    fi
}

#
# @description
#
# Called when the plugin is unloaded to clean up after itself.
#
# @noargs
#
# @set GCLOUD_SDK_HOME path The root directory for the SDK installation.
#
gcloud_plugin_unload() {
    builtin emulate -L zsh

    # Reset global environment variables.
    @zplugins_envvar_restore gcloud GCLOUD_SDK_HOME
}
