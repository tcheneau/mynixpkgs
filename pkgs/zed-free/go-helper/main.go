package main

import (
	"bytes"
	"debug/elf"
	"encoding/binary"
	"fmt"
	"log"
	"os"
	"reflect"

	"github.com/lunixbochs/struc"
)

func printUsageAndExit() {
	fmt.Println("program path_to_binary")
	os.Exit(0)
}

type Header struct {
	Magic              int    `struc:"uint32"`
	Class              byte   `struc:"uint8"`
	Data               byte   `struc:"uint8"`
	Version            byte   `struc:"uint8"`
	ABI                byte   `struc:"uint8"`
	ABIVersion         byte   `struc:"uint8"`
	Padding            []byte `struc:"[7]uint8"`
	Type               uint   `struc:"uint16"`
	Machine            uint   `struc:"uint16"`
	Version2           uint   `struc:"uint32"`
	Entry              uint   `struc:"uint64"`
	PhOffset           uint   `struc:"uint64"`
	SectionOffset      uint   `struc:"uint64"`
	Flags              uint   `struc:"uint32"`
	EhSize             uint   `struc:"uint16"`
	ProgHeaderSize     uint   `struc:"uint16"`
	ProgHeaderNum      uint   `struc:"uint16"`
	SectionHeaderSized uint   `struc:"uint16"`
	SectionHeaderNum   uint   `struc:"uint16"`
	SectionHeaderIdx   uint   `struc:"uint16"`
}

type SectionHeader struct {
	Name      uint `struc:"uint32"`
	Type      uint `struc:"uint32"`
	Flags     uint `struc:"uint64"`
	Addr      uint `struc:"uint64"`
	Offset    uint `struc:"uint64"`
	Size      uint `struc:"uint64"`
	Link      uint `struc:"uint32"`
	Info      uint `struc:"uint32"`
	AddrAlign uint `struc:"uint64"`
	EntSize   uint `struc:"uint64"`
}

type VerneedHeader struct {
	Version uint `struc:"uint16"`
	Cnt     uint `struc:"uint16"`
	File    uint `struc:"uint32"`
	Aux     uint `struc:"uint32"`
	Next    uint `struc:"uint32"`
}

type VernauxHeader struct {
	Hash  uint `struc:"uint32"`
	Flags uint `struc:"uint16"`
	Other uint `struc:"uint16"`
	Name  uint `struc:"uint32"`
	Next  uint `struc:"uint32"`
}

func printHexHeader(i interface{}) {

	switch t := i.(type) {
	case Header:
		s := reflect.ValueOf(&t).Elem()
		typeOfT := s.Type()

		for i := 0; i < s.NumField(); i++ {
			f := s.Field(i)
			fmt.Printf("%d: %s %s = %x\n", i,
				typeOfT.Field(i).Name, f.Type(), f.Interface())
		}
	case SectionHeader:
		s := reflect.ValueOf(&t).Elem()
		typeOfT := s.Type()

		for i := 0; i < s.NumField(); i++ {
			f := s.Field(i)
			fmt.Printf("%d: %s %s = %x\n", i,
				typeOfT.Field(i).Name, f.Type(), f.Interface())
		}
	case VerneedHeader:
		s := reflect.ValueOf(&t).Elem()
		typeOfT := s.Type()

		for i := 0; i < s.NumField(); i++ {
			f := s.Field(i)
			fmt.Printf("%d: %s %s = %x\n", i,
				typeOfT.Field(i).Name, f.Type(), f.Interface())
		}
	case VernauxHeader:
		s := reflect.ValueOf(&t).Elem()
		typeOfT := s.Type()

		for i := 0; i < s.NumField(); i++ {
			f := s.Field(i)
			fmt.Printf("%d: %s %s = %x\n", i,
				typeOfT.Field(i).Name, f.Type(), f.Interface())
		}
	}

}

func main() {
	fmt.Println(os.Args[0])

	if len(os.Args) != 2 {
		printUsageAndExit()
	}

	fileContent, err := elf.Open(os.Args[1])

	if err != nil {
		log.Fatal(err)
	}
	defer fileContent.Close()

	fmt.Println(fileContent.Section(".gnu.version_r").Name)
	fmt.Println(fileContent.ByteOrder)
	fmt.Printf("%x\n", fileContent.Section(".gnu.version_r").Open())

	bin, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer bin.Close()

	fileInfo, err := os.Stat(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	buf := make([]byte, fileInfo.Size())

	n, err := bin.Read(buf)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Reading bytes:", n)

	buffer := bytes.NewBuffer(buf)

	options := &struc.Options{}
	options.Order = binary.LittleEndian

	h := &Header{}
	err = struc.UnpackWithOptions(buffer, h, options)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Elf Header: %+v", h)
	printHexHeader(*h)

	// decode .gnu.version_r section manually
	buffer = bytes.NewBuffer(buf[h.SectionOffset+8*64:])

	sh := &SectionHeader{}
	err = struc.UnpackWithOptions(buffer, sh, options)
	if err != nil {
		log.Fatal(err)
	}

	printHexHeader(*sh)

	// edit section header to remove .gnu.version_r
	buffer = new(bytes.Buffer)
	sh.Name = 0x00
	sh.Type = 0x00
	err = struc.PackWithOptions(buffer, sh, options)
	if err != nil {
		log.Fatal(err)
	}
	buffer.Read(buf[h.SectionOffset+8*64 : h.SectionOffset+8*64+64])

	fmt.Println(h.SectionOffset + 8*64 + 4)
	fmt.Printf("%x\n", h.SectionOffset+8*64+4)

	buffer = bytes.NewBuffer(buf[sh.Offset:])

	vn := &VerneedHeader{}

	err = struc.UnpackWithOptions(buffer, vn, options)
	if err != nil {
		log.Fatal(err)
	}

	printHexHeader(*vn)
	fmt.Printf("%s\n", buf[vn.File:vn.File+10])

	buffer = bytes.NewBuffer(buf[sh.Offset+uint(vn.Aux):])

	vaux := &VernauxHeader{}

	err = struc.UnpackWithOptions(buffer, vaux, options)
	if err != nil {
		log.Fatal(err)
	}

	printHexHeader(*vaux)
	fmt.Printf("%s\n", buf[vaux.Name:vaux.Name+10])

	f, _ := os.Create("test")
	defer f.Close()

	f.Write(buf)

	return
}
