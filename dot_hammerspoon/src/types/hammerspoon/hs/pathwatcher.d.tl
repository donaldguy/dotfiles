local record pathwatcher
  record instance
    start: function(self: instance): instance
    stop:  function(self: instance): instance
  end


  -- these correspond to FSEventStreamEventFlags
  -- see also: https://developer.apple.com/documentation/coreservices/file_system_events/1455361-fseventstreameventflags
  -- https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html
  record fsEventStreamEventFlags
    mustScanSubDirs: boolean
    userDropped: boolean
    kernelDropped: boolean
    eventIdsWrapped: boolean
    historyDone: boolean
    rootChanged: boolean
    mount: boolean
    unmount: boolean
    itemCreated: boolean
    itemRemoved: boolean
    itemInodeMetaMod: boolean
    itemRenamed: boolean
    itemModified: boolean
    itemFinderInfoMod: boolean
    itemChangeOwner: boolean
    itemXattrMod: boolean
    itemIsFile: boolean
    itemIsDir: boolean
    itemIsSymlink: boolean
    ownEvent: boolean
    itemIsHardlink: boolean
    itemIsLastHardlink: boolean
  end

  new: function(path: string, function({string}, {fsEventStreamEventFlags})): instance
  type flags = fsEventStreamEventFlags
end

return pathwatcher
