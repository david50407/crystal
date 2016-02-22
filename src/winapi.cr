lib WinApi
  alias SizeT = LibC::SizeT

  ifdef x86_64
    alias IntPtr = Int64
  else
    alias IntPtr = Int32
  end

  alias Handle = Void*
  alias HModule = Handle
  alias HInstance = Handle
  alias DWord = UInt32
  alias LPVoid = IntPtr

  INVALID_HANDLE_VALUE = -1
  INVALID_HANDLE = Pointer(Void).new INVALID_HANDLE_VALUE
end

require "./winapi/*"
