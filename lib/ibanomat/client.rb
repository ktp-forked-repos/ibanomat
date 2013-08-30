require 'rest-client'
require 'json'

module Ibanomat
  URL = 'http://www.sparkasse.de/firmenkunden/konto-karte/iban-resources/iban/iban.php'

  def self.find(options)
    raise ArgumentError.new unless options.is_a?(Hash)
    raise ArgumentError.new('Option :bank_code is missing!') if options[:bank_code].empty?
    raise ArgumentError.new('Option :bank_code_number is missing!') if options[:bank_account_number].empty?

    response = RestClient.get URL, {
                                :params => {
                                  'bank-code'           => options[:bank_code],
                                  'bank-account-number' => options[:bank_account_number]
                                },
                                :accept => :json
                              }
    if response.code == 200
      hash = JSON.parse(response)

      case hash['RetCode']
      when '00'
        { :bank_name => hash['Institutsname'],
          :bic       => hash['BIC'],
          :iban      => hash['IBAN']
        }
      else
        :error
      end
    end
  end
end