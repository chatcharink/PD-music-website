Rails.application.config.session_store :active_record_store,
    :key => '_pd_music_website_session',
    :expire_after => 1.hour