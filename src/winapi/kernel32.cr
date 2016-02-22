@[Link("kernel32")]
lib WinApi
  # Memory mapping BEGIN
  struct SecurityAttributes
    length : DWord
    securityDescriptor : IntPtr
    inheritHandle : Bool
  end

  PAGE_NOACCESS  = 0x01
  PAGE_READONLY  = 0x02
  PAGE_READWRITE = 0x04
  PAGE_WRITECOPY = 0x08

  # TODO: unicode?
  @[CallConvention("X86_StdCall")]
  fun create_file_mapping = CreateFileMappingA(file : Handle, attributes : SecurityAttributes*, protect : DWord,
                                              maximum_size_high : DWord, maximum_size_low : DWord, name : Char*) : Handle

  @[CallConvention("X86_StdCall")]
  fun map_view_of_file = MapViewOfFile(file_mapping_object : Handle, desired_access : DWord,
                                       file_offsethigh : DWord, file_offset_low : DWord, number_of_bytes_to_map : SizeT) : Handle

  @[CallConvention("X86_StdCall")]
  fun unmap_view_of_file = UnmapViewOfFile(base_adderss : Handle) : Bool

  @[CallConvention("X86_StdCall")]
  fun close_handle = CloseHandle(object : Handle) : Bool
  # Memory mapping END

  # Dynamic-link Library BEGIN
  @[CallConvention("X86_StdCall")]
  fun load_library = LoadLibrary(file_name : Char*) : HModule

  @[CallConvention("X86_StdCall")]
  fun load_library_ex = LoadLibraryEx(file_name : Char*, file : Handle, flags : DWord) : HModule

  @[CallConvention("X86_StdCall")]
  fun get_proc_address = GetProcAddress(module_ : HModule, proc_name : Char*) : -> Int32
  # Dynamic-link Library END
end
