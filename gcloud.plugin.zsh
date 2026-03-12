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

#
# @description
#
# Set the environment for the Google Cloud SDK and CLI.
#
# @noargs
#
# @set GCLOUD_SDK_HOME path The root directory for the SDK installation.
#
gcloud_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Export any additional environment variables here.
    @zplugin_save_global gcloud GCLOUD_SDK_HOME

    local cask_path="$(homebrew_cask_prefix gcloud-cli)"

    if [[ -n "${cask_path}" ]]; then
        export GCLOUD_SDK_HOME="${cask_path}/latest/google-cloud-sdk"
        return 0
    else
        log-error "zsh-gcloud: the Homebrew cask 'gcloud-cli' does not seem to be installed."
        return 1
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
    @zplugin_restore_global gcloud GCLOUD_SDK_HOME
}
