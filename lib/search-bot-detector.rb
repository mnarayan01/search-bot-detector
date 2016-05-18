require "search-bot-detector/version"

class SearchBotDetector
  # @see https://support.google.com/webmasters/answer/80553?hl=en
  GOOGLE_HOSTNAME_SUFFIXES = %w(.googlebot.com .google.com).freeze

  # @see https://support.google.com/webmasters/answer/80553?hl=en
  GOOGLE_USER_AGENT_SUBSTR = "Googlebot".freeze

  # @see https://yandex.com/support/webmaster/robot-workings/check-yandex-robots.xml
  YANDEX_HOSTNAME_SUFFIXES = %w(.yandex.ru .yandex.net .yandex.com).freeze

  # @see https://yandex.com/support/webmaster/robot-workings/check-yandex-robots.xml
  YANDEX_USER_AGENT_SUBSTR = "+http://yandex.com/bots".freeze

  # @param [String] ip
  # @param [String] user_agent
  def initialize(ip, user_agent)
    @ip = ip or raise ArgumentError
    @user_agent = user_agent or raise ArgumentError
  end

  # @!attribute [r] ip
  #   @return [String]
  attr_reader :ip

  # @!attribute [r] user_agent
  #   @return [String]
  attr_reader :user_agent

  # @return [Boolean]
  def any_bot?
    google_bot? || yandex_bot?
  end

  # @return [Boolean]
  def google_bot?
    user_agent.include?(GOOGLE_USER_AGENT_SUBSTR) && hostname_matches?(GOOGLE_HOSTNAME_SUFFIXES)
  end

  # @return [Boolean]
  def yandex_bot?
    user_agent.include?(YANDEX_USER_AGENT_SUBSTR) && hostname_matches?(YANDEX_HOSTNAME_SUFFIXES)
  end

  protected

  # Check if the resolved and verified `hostname` matches any of the provided suffixes.
  #
  # @param [Array<String>]
  #
  # @return [Boolean]
  def hostname_matches?(hostname_suffixes)
    # N.B.: The ordering here is important:
    #
    # 1.  Get the _unverified_ hostname.
    # 2.  Check if it matches.
    # 3.  Verify the hostname against the IP.
    #
    # This is important to avoid a potentially long call to `Resolv::getaddresses` with an attacker-controlled hostname.

    hostname = unverified_hostname or return false
    hostname_suffixes.any? { |hostname_suffix| hostname.end_with?(hostname_suffix) } or return false

    hostname == verified_hostname
  end

  private

  # @return [String, nil]
  def unverified_hostname
    return @unverified_hostname if defined?(@unverified_hostname)

    @unverified_hostname =
      begin
        Resolv.getname(ip)
      rescue Resolv::ResolvError
        nil
      end
  end

  # @note Should only be called after it has been checked that {#unverified_hostname} is not attacker controlled.
  #
  # @return [String, nil]
  def verified_hostname
    return @verified_hostname if defined?(@verified_hostname)

    # N.B.: Not rescuing `Resolv::ResolvError` as the hostname should not be attacker controlled, and thus presumably
    #   should resolve successfully.
    @verified_hostname =
      if (hostname = unverified_hostname) && Resolv.getaddresses(hostname).include?(ip)
        hostname
      end
  end
end
