module Private
  class AssetsController < BaseController
    skip_before_action :auth_member!, only: [:index]

    def index
      @nzd_assets  = Currency.assets('nzd')
      @btc_proof   = Proof.current :btc
      @nzd_proof   = Proof.current :nzd

      if current_user
        @btc_account = current_user.accounts.with_currency(:btc).first
        @nzd_account = current_user.accounts.with_currency(:nzd).first
      end
    end

    def partial_tree
      account    = current_user.accounts.with_currency(params[:id]).first
      @timestamp = Proof.with_currency(params[:id]).last.timestamp
      @json      = account.partial_tree.to_json.html_safe
      respond_to do |format|
        format.js
      end
    end

  end
end
