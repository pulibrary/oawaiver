# frozen_string_literal: true

namespace :sunspot do
  namespace :solr do
    desc 'delete all indexes'
    task zap_index: [:environment] do
      Sunspot.remove_all
    end

    desc 'optimize solr index'
    task optimize: [:environment] do
      res = Sunspot.optimize
      puts 'Sunspot.optimize ' + res.inspect
    end
  end
end
