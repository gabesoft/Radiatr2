module HudsonConnector
  def latest_build
    full_data = { :healthReport => { :score => 10 }}
    data = { :fullDisplayName => 'Generated', :changeSet => { :items => [{:user => 'Bob'}]}, :building => true, :result => 'Fail'}

    { :job => data[:fullDisplayName], :project => 'None', :health => full_data[:healthReport][:score],
      :committers => data[:changeSet][:items][0][:user], :building => data[:building], :status => data[:result]}
  end
end
