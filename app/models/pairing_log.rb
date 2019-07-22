class PairingLog < ApplicationRecord
    validates :name,
    length: {maximum: 50},
    format: {with: /\A[a-z0-9]+\z/i }

    def past_partners(event,id)
        partners = []
        PairingLog.where(event: event).each { |log|
            data = JSON.parse(log.data).with_indifferent_access
            data[:pairs].each{ |pair|
                if pair.include?(id) 
                    pair.delete(id) 
                    partners.push(pair[0])
                end
            }
        }
        partners
    end

    def canBePair(event,x,y)
        partners = past_partners(event,x)
        not partners.include?(y)
    end

end
